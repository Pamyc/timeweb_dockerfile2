export default async function Page() {
  let data;
  try {
    const res = await fetch('http://127.0.0.1:5000/hello', { cache: 'no-store' });
    if (!res.ok) throw new Error('Bad status');
    data = await res.json();
  } catch {
    data = { msg: 'API недоступно', ok: false };
  }
  return (
    <main>
      <h1>Next.js + Flask (один контейнер)</h1>
      <p>Страница Next.js (App Router). Ниже ответ Flask API:</p>
      <pre>{JSON.stringify(data, null, 2)}</pre>
    </main>
  );
}
