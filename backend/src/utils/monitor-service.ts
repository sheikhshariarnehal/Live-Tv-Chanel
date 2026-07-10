import http from 'http';
import https from 'https';
import { URL } from 'url';
import { createAdminSupabaseClient } from './supabase';

interface TimingResult {
  dns: number;
  tcp: number;
  tls: number;
  ttfb: number;
  total: number;
  statusCode: number;
  headers: http.IncomingHttpHeaders;
  body: string;
  error?: string;
}

// Global scheduler state
declare global {
  var monitorIntervalId: NodeJS.Timeout | undefined;
  var isScanningNow: boolean;
  var lastScanTime: string | undefined;
}

if (global.isScanningNow === undefined) {
  global.isScanningNow = false;
}

const PROXY_WORKER_URL = 'https://live-stream-proxy.sheikhshariarnehal.workers.dev/?url=';

/**
 * Basic connection and HTTP timing test
 */
export function testStreamUrl(
  urlStr: string,
  options: {
    timeout?: number;
    headers?: Record<string, string>;
    method?: string;
  } = {}
): Promise<TimingResult> {
  return new Promise((resolve) => {
    try {
      const url = new URL(urlStr);
      const isHttps = url.protocol === 'https:';
      const lib = isHttps ? https : http;

      const requestOptions: http.RequestOptions | https.RequestOptions = {
        hostname: url.hostname,
        port: url.port || (isHttps ? 443 : 80),
        path: url.pathname + url.search,
        method: options.method || 'GET',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          ...options.headers,
        },
        timeout: options.timeout || 8000,
      };

      const startTime = process.hrtime();
      let dnsTime = 0;
      let tcpTime = 0;
      let tlsTime = 0;
      let ttfbTime = 0;
      let totalTime = 0;

      const bodyChunks: Buffer[] = [];
      let completed = false;

      const req = lib.request(requestOptions, (res) => {
        const diff = process.hrtime(startTime);
        ttfbTime = Math.round(diff[0] * 1000 + diff[1] / 1000000);

        res.on('data', (chunk) => {
          bodyChunks.push(chunk);
          // Limit manifest downloading to 128KB to prevent memory exhaustion
          const totalSize = bodyChunks.reduce((acc, c) => acc + c.length, 0);
          if (totalSize > 131072) {
            req.destroy();
          }
        });

        res.on('end', () => {
          if (completed) return;
          completed = true;
          const diffEnd = process.hrtime(startTime);
          totalTime = Math.round(diffEnd[0] * 1000 + diffEnd[1] / 1000000);
          
          const body = Buffer.concat(bodyChunks).toString('utf8');
          resolve({
            dns: dnsTime,
            tcp: tcpTime,
            tls: tlsTime,
            ttfb: ttfbTime,
            total: totalTime,
            statusCode: res.statusCode || 0,
            headers: res.headers,
            body,
          });
        });
      });

      req.on('socket', (socket) => {
        socket.on('lookup', () => {
          const diff = process.hrtime(startTime);
          dnsTime = Math.round(diff[0] * 1000 + diff[1] / 1000000);
        });

        socket.on('connect', () => {
          const diff = process.hrtime(startTime);
          tcpTime = Math.round(diff[0] * 1000 + diff[1] / 1000000) - dnsTime;
        });

        if (isHttps) {
          socket.on('secureConnect', () => {
            const diff = process.hrtime(startTime);
            tlsTime = Math.round(diff[0] * 1000 + diff[1] / 1000000) - (dnsTime + tcpTime);
          });
        }
      });

      req.on('timeout', () => {
        req.destroy();
        if (completed) return;
        completed = true;
        const diff = process.hrtime(startTime);
        const took = Math.round(diff[0] * 1000 + diff[1] / 1000000);
        resolve({
          dns: dnsTime,
          tcp: tcpTime,
          tls: tlsTime,
          ttfb: ttfbTime,
          total: took,
          statusCode: 0,
          headers: {},
          body: '',
          error: 'Timeout',
        });
      });

      req.on('error', (err) => {
        if (completed) return;
        completed = true;
        const diff = process.hrtime(startTime);
        const took = Math.round(diff[0] * 1000 + diff[1] / 1000000);
        resolve({
          dns: dnsTime,
          tcp: tcpTime,
          tls: tlsTime,
          ttfb: ttfbTime,
          total: took,
          statusCode: 0,
          headers: {},
          body: '',
          error: err.message,
        });
      });

      req.end();
    } catch (err) {
      const errMsg = err instanceof Error ? err.message : String(err);
      resolve({
        dns: 0,
        tcp: 0,
        tls: 0,
        ttfb: 0,
        total: 0,
        statusCode: 0,
        headers: {},
        body: '',
        error: errMsg,
      });
    }
  });
}

/**
 * Fetch and follow HTTP redirects while measuring timing
 */
export async function fetchWithTiming(
  urlStr: string,
  options: {
    timeout?: number;
    headers?: Record<string, string>;
    method?: string;
    maxRedirects?: number;
  } = {}
): Promise<TimingResult> {
  let redirects = 0;
  let currentUrl = urlStr;
  const maxRedirects = options.maxRedirects ?? 5;
  
  let accumulatedDns = 0;
  let accumulatedTcp = 0;
  let accumulatedTls = 0;
  let accumulatedTtfb = 0;
  let accumulatedTotal = 0;

  while (redirects <= maxRedirects) {
    const result = await testStreamUrl(currentUrl, options);
    accumulatedDns += result.dns;
    accumulatedTcp += result.tcp;
    accumulatedTls += result.tls;
    accumulatedTtfb += result.ttfb;
    accumulatedTotal += result.total;

    if (result.statusCode >= 300 && result.statusCode < 400 && result.headers.location) {
      redirects++;
      try {
        currentUrl = new URL(result.headers.location, currentUrl).toString();
      } catch {
        return {
          dns: accumulatedDns,
          tcp: accumulatedTcp,
          tls: accumulatedTls,
          ttfb: accumulatedTtfb,
          total: accumulatedTotal,
          statusCode: result.statusCode,
          headers: result.headers,
          body: result.body,
          error: 'Invalid Redirect Location',
        };
      }
      continue;
    }

    return {
      dns: accumulatedDns,
      tcp: accumulatedTcp,
      tls: accumulatedTls,
      ttfb: accumulatedTtfb,
      total: accumulatedTotal,
      statusCode: result.statusCode,
      headers: result.headers,
      body: result.body,
      error: result.error,
    };
  }

  return {
    dns: accumulatedDns,
    tcp: accumulatedTcp,
    tls: accumulatedTls,
    ttfb: accumulatedTtfb,
    total: accumulatedTotal,
    statusCode: 310,
    headers: {},
    body: '',
    error: 'Too many redirects',
  };
}

/**
 * Parses HLS Master/Media playlists
 */
function parseHlsPlaylist(body: string, baseUrl: string): { type: 'master' | 'media', firstUrl: string | null } {
  const lines = body.split('\n').map(l => l.trim()).filter(l => l.length > 0);
  
  // Media playlist verification
  const isMedia = lines.some(l => l.startsWith('#EXTINF'));
  if (isMedia) {
    for (let i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('#EXTINF')) {
        for (let j = i + 1; j < lines.length; j++) {
          if (!lines[j].startsWith('#')) {
            return { type: 'media', firstUrl: resolveUrl(lines[j], baseUrl) };
          }
        }
      }
    }
  }

  // Master playlist verification
  const isMaster = lines.some(l => l.startsWith('#EXT-X-STREAM-INF'));
  if (isMaster) {
    for (let i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('#EXT-X-STREAM-INF')) {
        for (let j = i + 1; j < lines.length; j++) {
          if (!lines[j].startsWith('#')) {
            return { type: 'master', firstUrl: resolveUrl(lines[j], baseUrl) };
          }
        }
      }
    }
  }

  // Fallback
  for (const line of lines) {
    if (!line.startsWith('#') && (line.includes('.m3u8') || line.includes('.ts') || line.includes('.m4s') || line.includes('.mp4') || line.startsWith('http'))) {
      return { type: 'media', firstUrl: resolveUrl(line, baseUrl) };
    }
  }

  return { type: 'media', firstUrl: null };
}

/**
 * Resolves a URL path against a base
 */
function resolveUrl(url: string, base: string): string {
  try {
    return new URL(url, base).toString();
  } catch {
    return url;
  }
}

/**
 * Parses DASH MPD Manifest for the first segment/initialization
 */
function parseDashManifest(body: string, baseUrl: string): string | null {
  let localBaseUrl = baseUrl;
  const baseUrlMatch = body.match(/<BaseURL>([^<]+)<\/BaseURL>/i);
  if (baseUrlMatch) {
    localBaseUrl = resolveUrl(baseUrlMatch[1].trim(), baseUrl);
  }

  // 1. Initialization segment
  const initMatch = body.match(/<Initialization[^>]+sourceURL=["']([^"']+)["']/i);
  if (initMatch) {
    return resolveUrl(initMatch[1], localBaseUrl);
  }

  // 2. Direct segment url
  const segmentMatch = body.match(/<SegmentURL[^>]+media=["']([^"']+)["']/i);
  if (segmentMatch) {
    return resolveUrl(segmentMatch[1], localBaseUrl);
  }

  // 3. SegmentTemplate template
  const templateMatch = body.match(/<SegmentTemplate[^>]+(media|initialization)=["']([^"']+)["']/i);
  if (templateMatch) {
    let mediaUrl = templateMatch[2];
    mediaUrl = mediaUrl
      .replace(/\$Number\$/g, '1')
      .replace(/\$RepresentationID\$/g, '1')
      .replace(/\$Time\$/g, '0');
    return resolveUrl(mediaUrl, localBaseUrl);
  }

  return null;
}

/**
 * Tests segment connection without downloading the full file
 */
export function testSegmentUrl(
  urlStr: string,
  headers: Record<string, string> = {},
  timeout = 5000
): Promise<boolean> {
  return new Promise((resolve) => {
    try {
      const url = new URL(urlStr);
      const isHttps = url.protocol === 'https:';
      const lib = isHttps ? https : http;

      const req = lib.request({
        hostname: url.hostname,
        port: url.port || (isHttps ? 443 : 80),
        path: url.pathname + url.search,
        method: 'GET',
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          ...headers,
        },
        timeout,
      }, (res) => {
        req.destroy();
        resolve(!!res.statusCode && res.statusCode >= 200 && res.statusCode < 400);
      });

      req.on('error', () => resolve(false));
      req.on('timeout', () => {
        req.destroy();
        resolve(false);
      });
      req.end();
    } catch {
      resolve(false);
    }
  });
}

/**
 * Detect Geo Restriction message or status
 */
function detectGeoRestriction(statusCode: number, body: string, error?: string): { restricted: boolean; reason: string | null } {
  if (statusCode === 403 || statusCode === 451) {
    return { restricted: true, reason: `HTTP ${statusCode}: Forbidden/Geo-restricted` };
  }
  const bodyLower = body.toLowerCase();
  if (bodyLower.includes('geo block') || bodyLower.includes('geoblock') || bodyLower.includes('geo-restricted') || bodyLower.includes('geo restricted')) {
    return { restricted: true, reason: 'Geo-blocked message in body' };
  }
  if (bodyLower.includes('cloudflare blocked') || bodyLower.includes('error 1020') || bodyLower.includes('access denied') || bodyLower.includes('forbidden')) {
    return { restricted: true, reason: 'CDN/WAF Access Denied' };
  }
  if (error && (error.includes('403') || error.includes('451'))) {
    return { restricted: true, reason: `Error: ${error}` };
  }
  return { restricted: false, reason: null };
}

/**
 * Concurrency runner pool
 */
async function runWithConcurrency<T>(
  tasks: (() => Promise<T>)[],
  concurrencyLimit: number
): Promise<T[]> {
  const results: T[] = [];
  let index = 0;
  const activePromises: Promise<void>[] = [];

  async function worker() {
    while (index < tasks.length) {
      const taskIndex = index++;
      const task = tasks[taskIndex];
      try {
        results[taskIndex] = await task();
      } catch {
        // Catch transient errors
      }
    }
  }

  for (let i = 0; i < Math.min(concurrencyLimit, tasks.length); i++) {
    activePromises.push(worker());
  }

  await Promise.all(activePromises);
  return results;
}

export interface ChannelDbRow {
  id: string;
  name: string;
  stream_url: string;
  headers?: Record<string, string>;
  proxy?: boolean;
  drm?: {
    type?: string;
    kid?: string;
    key?: string;
    licenseUrl?: string;
    headers?: Record<string, string>;
  } | null;
}

export interface ScanResult {
  channel_id: string;
  status: string;
  http_status: number;
  response_time: number;
  playlist_status: string;
  segment_status: string;
  proxy_status: string;
  drm_status: string;
  headers_status: string;
  geo_status: string;
  error_message: string | null;
  checked_at: string;
}

/**
 * Run a single channel check
 */
export async function scanChannel(channel: ChannelDbRow): Promise<ScanResult> {
  const streamUrl = channel.stream_url;
  const headers = (channel.headers as Record<string, string>) || {};
  const drm = channel.drm || null;

  let httpStatus = 0;
  let responseTime = 0;
  let playlistStatus = 'SKIPPED';
  let segmentStatus = 'SKIPPED';
  let proxyStatus = 'SKIPPED';
  let drmStatus = 'SKIPPED';
  let headersStatus = 'OK';
  let geoStatus = 'OK';
  let errorMessage: string | null = null;
  let geoReason: string | null = null;
  let headersWarning: string | null = null;

  // 1. Header Validation
  const host = new URL(streamUrl).hostname;
  const hasReferer = Object.keys(headers).some(k => k.toLowerCase() === 'referer');
  const hasUA = Object.keys(headers).some(k => k.toLowerCase() === 'user-agent');
  
  if ((host.includes('toffee') || host.includes('livekhelatv') || host.includes('starhub.pro')) && (!hasReferer || !hasUA)) {
    headersStatus = 'WARNING';
    headersWarning = `Missing suggested headers (Referer/User-Agent) for host ${host}`;
  }

  // 2. HTTP Timing & Playlist check
  const mainCheck = await fetchWithTiming(streamUrl, { headers });
  responseTime = mainCheck.total;
  httpStatus = mainCheck.statusCode;

  if (mainCheck.error) {
    errorMessage = mainCheck.error;
  }

  const geoCheck = detectGeoRestriction(mainCheck.statusCode, mainCheck.body, mainCheck.error);
  if (geoCheck.restricted) {
    geoStatus = 'GEO_BLOCKED';
    geoReason = geoCheck.reason;
  }

  const isM3u8 = streamUrl.toLowerCase().includes('.m3u8') || (mainCheck.headers['content-type'] || '').includes('mpegurl');
  const isMpd = streamUrl.toLowerCase().includes('.mpd') || (mainCheck.headers['content-type'] || '').includes('dash+xml');

  let resolvedSegmentUrl: string | null = null;

  if (mainCheck.statusCode === 200) {
    if (isM3u8) {
      if (mainCheck.body.trim().startsWith('#EXTM3U')) {
        playlistStatus = 'OK';
        // Parse segments
        const parsed = parseHlsPlaylist(mainCheck.body, streamUrl);
        if (parsed.type === 'master' && parsed.firstUrl) {
          // It's a master playlist, fetch the media playlist
          const mediaPlaylist = await fetchWithTiming(parsed.firstUrl, { headers });
          if (mediaPlaylist.statusCode === 200) {
            const mediaParsed = parseHlsPlaylist(mediaPlaylist.body, parsed.firstUrl);
            resolvedSegmentUrl = mediaParsed.firstUrl;
          }
        } else {
          resolvedSegmentUrl = parsed.firstUrl;
        }
      } else {
        playlistStatus = 'INVALID_FORMAT';
        errorMessage = 'HLS Playlist does not start with #EXTM3U';
      }
    } else if (isMpd) {
      if (mainCheck.body.includes('<MPD') && mainCheck.body.includes('<AdaptationSet')) {
        playlistStatus = 'OK';
        resolvedSegmentUrl = parseDashManifest(mainCheck.body, streamUrl);
      } else {
        playlistStatus = 'INVALID_FORMAT';
        errorMessage = 'DASH Manifest does not contain MPD/AdaptationSet';
      }
    } else {
      playlistStatus = 'OK'; // Direct video format
    }

    // 3. Segment verification
    if (resolvedSegmentUrl) {
      const segOk = await testSegmentUrl(resolvedSegmentUrl, headers);
      segmentStatus = segOk ? 'OK' : 'FAILED';
      if (!segOk && !errorMessage) {
        errorMessage = 'Failed to load media segment';
      }
    } else if (playlistStatus === 'OK') {
      segmentStatus = 'SKIPPED';
    } else {
      segmentStatus = 'FAILED';
    }

    // 4. DRM Check
    if (drm && drm.type) {
      if (drm.type === 'clearkey') {
        if (drm.kid && drm.key) {
          drmStatus = 'OK';
        } else {
          drmStatus = 'FAILED';
          errorMessage = 'DRM ClearKey configuration is missing KIDs/Keys';
        }
      } else if (drm.type === 'widevine') {
        if (drm.licenseUrl) {
          // Ping license URL
          const wvRes = await testStreamUrl(drm.licenseUrl, { method: 'GET', headers: drm.headers || {} });
          // License servers often reject GET with 400/405, which means they are reachable!
          // If status is >= 500 or dns/conn error, then it failed
          if (wvRes.error && wvRes.error !== 'Timeout' && !wvRes.statusCode) {
            drmStatus = 'FAILED';
            errorMessage = `DRM Widevine License unreachable: ${wvRes.error}`;
          } else {
            drmStatus = 'OK';
          }
        } else {
          drmStatus = 'FAILED';
          errorMessage = 'DRM Widevine License URL is not configured';
        }
      } else {
        drmStatus = 'OK';
      }
    }
  } else {
    playlistStatus = 'FAILED';
    segmentStatus = 'FAILED';
    if (drm && drm.type) drmStatus = 'FAILED';
  }

  // 5. Proxy Validation
  const directOk = mainCheck.statusCode === 200 && segmentStatus !== 'FAILED' && drmStatus !== 'FAILED';
  let proxyOk = false;

  const proxyUrl = PROXY_WORKER_URL + encodeURIComponent(streamUrl);
  const proxyCheck = await fetchWithTiming(proxyUrl, { headers });
  
  if (proxyCheck.statusCode === 200) {
    let proxySegUrl: string | null = null;
    if (isM3u8) {
      if (proxyCheck.body.trim().startsWith('#EXTM3U')) {
        const parsed = parseHlsPlaylist(proxyCheck.body, proxyUrl);
        proxySegUrl = parsed.firstUrl;
      }
    } else if (isMpd) {
      if (proxyCheck.body.includes('<MPD')) {
        proxySegUrl = parseDashManifest(proxyCheck.body, proxyUrl);
      }
    } else {
      proxySegUrl = proxyUrl;
    }

    if (proxySegUrl) {
      proxyOk = await testSegmentUrl(proxySegUrl, headers);
    } else {
      proxyOk = true;
    }
  }

  if (directOk && proxyOk) {
    proxyStatus = 'Both';
  } else if (directOk) {
    proxyStatus = 'Direct';
  } else if (proxyOk) {
    proxyStatus = 'Proxy';
  } else {
    proxyStatus = 'Failed';
  }

  // Overall status resolve
  let status = 'working';
  if (mainCheck.statusCode !== 200 || segmentStatus === 'FAILED' || drmStatus === 'FAILED') {
    status = 'offline';
  } else if (responseTime > 3000) {
    status = 'slow';
  }

  return {
    channel_id: channel.id,
    status,
    http_status: httpStatus,
    response_time: responseTime,
    playlist_status: playlistStatus,
    segment_status: segmentStatus,
    proxy_status: proxyStatus,
    drm_status: drmStatus,
    headers_status: headersStatus,
    geo_status: geoStatus,
    error_message: errorMessage || geoReason || headersWarning || null,
    checked_at: new Date().toISOString(),
  };
}

/**
 * Triggers and performs the scan for all channels
 */
export async function runChannelScan(): Promise<{
  success: boolean;
  total: number;
  working: number;
  offline: number;
  slow: number;
  durationMs: number;
}> {
  if (global.isScanningNow) {
    throw new Error('Scan already in progress');
  }

  global.isScanningNow = true;
  const startTime = Date.now();
  
  const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';
  const supabaseAdmin = createAdminSupabaseClient(correctToken);

  try {
    console.log('Starting full channel health monitoring scan...');

    // Fetch all active channels using pagination (bypass 1000-row PostgREST limit)
    const BATCH_SIZE = 1000;
    let offset = 0;
    const channels: any[] = [];

    while (true) {
      const { data: batch, error: chErr } = await supabaseAdmin
        .from('channels')
        .select('*')
        .order('sort_order', { ascending: true })
        .range(offset, offset + BATCH_SIZE - 1);

      if (chErr) throw chErr;
      if (!batch || batch.length === 0) break;
      channels.push(...batch);

      if (batch.length < BATCH_SIZE) break;
      offset += BATCH_SIZE;
    }

    if (channels.length === 0) {
      console.log('No channels found to scan.');
      global.isScanningNow = false;
      return { success: true, total: 0, working: 0, offline: 0, slow: 0, durationMs: 0 };
    }

    console.log(`Scanning ${channels.length} channels with concurrency limit 15...`);

    // Create tasks
    const tasks = channels.map(ch => () => scanChannel(ch));
    
    // Run concurrency-limited scans
    const results = await runWithConcurrency(tasks, 15);

    let workingCount = 0;
    let offlineCount = 0;
    let slowCount = 0;

    // Save each channel results to database (channel_health and channel_health_history)
    for (const result of results) {
      if (!result) continue;

      if (result.status === 'working') workingCount++;
      else if (result.status === 'offline') offlineCount++;
      else if (result.status === 'slow') slowCount++;

      // 1. Update/Insert in channel_health
      const { error: upsertErr } = await supabaseAdmin
        .from('channel_health')
        .upsert({
          channel_id: result.channel_id,
          status: result.status,
          http_status: result.http_status,
          response_time: result.response_time,
          playlist_status: result.playlist_status,
          segment_status: result.segment_status,
          proxy_status: result.proxy_status,
          drm_status: result.drm_status,
          headers_status: result.headers_status,
          geo_status: result.geo_status,
          error_message: result.error_message,
          checked_at: result.checked_at,
          updated_at: new Date().toISOString()
        }, { onConflict: 'channel_id' });

      if (upsertErr) {
        console.error(`Failed to upsert channel health for ${result.channel_id}:`, upsertErr);
      }

      // 2. Insert into channel_health_history
      const { error: histErr } = await supabaseAdmin
        .from('channel_health_history')
        .insert({
          channel_id: result.channel_id,
          status: result.status,
          http_status: result.http_status,
          response_time: result.response_time,
          playlist_status: result.playlist_status,
          segment_status: result.segment_status,
          proxy_status: result.proxy_status,
          drm_status: result.drm_status,
          headers_status: result.headers_status,
          geo_status: result.geo_status,
          error_message: result.error_message,
          checked_at: result.checked_at
        });

      if (histErr) {
        console.error(`Failed to insert history log for ${result.channel_id}:`, histErr);
      }
    }

    const durationMs = Date.now() - startTime;

    // 3. Save to scan history (channel_health_scans)
    const { error: scanHistErr } = await supabaseAdmin
      .from('channel_health_scans')
      .insert({
        total_channels: channels.length,
        working_count: workingCount,
        offline_count: offlineCount,
        slow_count: slowCount,
        duration_ms: durationMs,
        scanned_at: new Date().toISOString()
      });

    if (scanHistErr) {
      console.error('Failed to log scan statistics history:', scanHistErr);
    }

    // 4. Log rotation - clean up records older than 7 days
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    const { error: deleteErr } = await supabaseAdmin
      .from('channel_health_history')
      .delete()
      .lt('created_at', sevenDaysAgo.toISOString());

    if (deleteErr) {
      console.error('Failed to prune old health history logs:', deleteErr);
    }

    console.log(`Health scan completed in ${durationMs}ms. Working: ${workingCount}, Offline: ${offlineCount}, Slow: ${slowCount}`);

    global.lastScanTime = new Date().toISOString();
    global.isScanningNow = false;
    return {
      success: true,
      total: channels.length,
      working: workingCount,
      offline: offlineCount,
      slow: slowCount,
      durationMs,
    };
  } catch (err) {
    console.error('Error during channel health monitoring scan:', err);
    global.isScanningNow = false;
    return {
      success: false,
      total: 0,
      working: 0,
      offline: 0,
      slow: 0,
      durationMs: Date.now() - startTime,
    };
  }
}

/**
 * Loads the current interval and schedules the next job
 */
export async function initializeScheduler() {
  const correctToken = process.env.ADMIN_SECRET_TOKEN || 'GoLiveAdminSecret2026';
  const supabaseAdmin = createAdminSupabaseClient(correctToken);

  try {
    // Fetch setting
    const { data: settings } = await supabaseAdmin
      .from('app_settings')
      .select('monitor_interval_minutes')
      .eq('id', 1)
      .single();

    const intervalMinutes = settings?.monitor_interval_minutes || 5;
    const intervalMs = intervalMinutes * 60 * 1000;

    console.log(`Scheduling Channel Health Monitor every ${intervalMinutes} minutes...`);

    if (global.monitorIntervalId) {
      clearInterval(global.monitorIntervalId);
    }

    // Start background scanner
    global.monitorIntervalId = setInterval(async () => {
      try {
        if (!global.isScanningNow) {
          await runChannelScan();
        }
      } catch (err) {
        console.error('Scheduled health check error:', err);
      }
    }, intervalMs);

  } catch (err) {
    console.error('Failed to initialize scheduler:', err);
  }
}
