# Next.js + Flask (один контейнер) для Timeweb Cloud (Apps > Dockerfile)

**Идея:** Один контейнер, один порт.
- Next.js (App Router) слушает `PORT` (по умолчанию 3000) и проксирует `/api/*` на Flask (`127.0.0.1:5000`) через `next.config.mjs -> rewrites()`.
- Flask запускается через gunicorn под supervisord.
- EXPOSE только 3000 — это и будет HTTP-порт приложения в Timeweb Apps.

## Локальный запуск (Docker)
```bash
docker build -t tw-next-flask .
docker run -p 3000:3000 tw-next-flask
# http://localhost:3000 (Next), http://localhost:3000/api/hello -> прокси на Flask
```

## На что смотреть, если 502
- Совпадает ли EXPOSE и реальный порт (3000).
- Есть ли `public/` (в этом проекте есть, чтобы COPY не падал).
- Логи рантайма: оба процесса должны работать (Next и gunicorn).
