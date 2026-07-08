import crypto from 'crypto';
import { getChannelsData } from '../../lib/supabase';

export async function GET({ request }) {
  try {
    const channelsData = await getChannelsData();
    const serializedData = JSON.stringify(channelsData);
    const etag = `W/"${crypto.createHash('sha1').update(serializedData).digest('hex')}"`;

    const ifNoneMatch = request.headers.get('if-none-match');

    if (ifNoneMatch === etag) {
      return new Response(null, {
        status: 304,
        headers: {
          'ETag': etag,
          'Cache-Control': 'public, max-age=2, stale-while-revalidate=60',
          'Access-Control-Allow-Origin': '*'
        }
      });
    }

    return new Response(serializedData, {
      status: 200,
      headers: {
        'Content-Type': 'application/json',
        'ETag': etag,
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'public, max-age=2, stale-while-revalidate=60'
      }
    });
  } catch (error) {
    console.error('Error serving channels from database:', error);
    return new Response(JSON.stringify({ error: 'Failed to fetch channels' }), {
      status: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      }
    });
  }
}
