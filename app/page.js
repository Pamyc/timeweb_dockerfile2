async function getHello() {
  const res = await fetch('/api/hello', { cache: 'no-store' });
  if (!res.ok) return { msg: 'API недоступно' };
  return res.json();
}

export default async function Page() {
  const data = await getHello();
  return (
    <main>
      <h1>Next.js + Flask (один контейнер)</h1>
      <p>Страница Next.js (App Router). Ниже ответ Flask API:</p>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </main>
  );
}
