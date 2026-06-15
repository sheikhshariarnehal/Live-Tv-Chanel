import localData from '../../../public/assets/data/channels.json';

export async function GET() {
  return new Response(JSON.stringify(localData), {
    status: 200,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Cache-Control': 'public, max-age=3600, stale-while-revalidate=86400'
    }
  });
}
