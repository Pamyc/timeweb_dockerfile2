# --- Node deps ---
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev --no-audit --no-fund; else npm install --omit=dev --no-audit --no-fund; fi

# --- Build Next ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# --- Runtime (Node 20) ---
FROM node:20-alpine AS runner
WORKDIR /app

# Python + pip + supervisor + wget (без апгрейда pip — важный момент для Alpine/PEP 668)
RUN apk add --no-cache python3 py3-pip supervisor wget

# Non-root user
RUN addgroup -g 1001 -S nodejs && adduser -S nextjs -u 1001

# Copy Next standalone
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public

# Copy Flask backend and install deps (разрешаем установку в системный префикс)
COPY backend ./backend
COPY requirements.txt ./requirements.txt
RUN if [ -f requirements.txt ]; then \
      python3 -m pip install --no-cache-dir --break-system-packages -r requirements.txt; \
    else \
      python3 -m pip install --no-cache-dir --break-system-packages -r backend/requirements.txt; \
    fi

# Supervisord
COPY ./.docker/supervisord.conf /etc/supervisord.conf

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
  CMD wget -qO- http://127.0.0.1:$PORT/ || exit 1


USER 1001
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
