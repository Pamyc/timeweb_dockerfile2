export const metadata = {
  title: 'Next + Flask on Timeweb',
  description: 'Single container: Next.js + Flask (supervisord).',
};

export default function RootLayout({ children }) {
  return (
    <html lang="ru">
      <body style={{fontFamily:'system-ui, -apple-system, Segoe UI, Roboto, sans-serif', padding: 24}}>
        {children}
      </body>
    </html>
  );
}
