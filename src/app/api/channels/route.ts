import crypto from 'crypto';
import localData from '@/data/channels.json';

const serializedData = JSON.stringify(localData);
const etag = `W/"${crypto.createHash('sha1').update(serializedData).digest('hex')}"`;

export const dynamic = 'force-dynamic';

export async function GET(request: Request) {
  const ifNoneMatch = request.headers.get('if-none-match');

  if (ifNoneMatch === etag) {
    return new Response(null, {
      status: 304,
      headers: {
        'ETag': etag,
        'Cache-Control': 'public, max-age=86400, stale-while-revalidate=604800',
        'Access-Control-Allow-Origin': '*',
      },
    });
  }

  return new Response(serializedData, {
    status: 200,
    headers: {
      'Content-Type': 'application/json',
      'ETag': etag,
      'Access-Control-Allow-Origin': '*',
      'Cache-Control': 'public, max-age=86400, stale-while-revalidate=604800',
    },
  });
}
