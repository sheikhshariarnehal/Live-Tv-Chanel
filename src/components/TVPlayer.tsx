'use client';

import { useEffect, useRef, useState } from 'react';
import { Channel } from '@/types';
import { useAppStore } from '@/stores/useAppStore';

// Declare global types for CDN-loaded libraries
declare global {
  interface Window {
    Artplayer: any;
    Hls: any;
    mpegts: any;
    shaka: any;
  }
}

interface TVPlayerProps {
  channel: Channel;
  onPlaybackError?: (err: any) => void;
}

const loadedScripts = new Set<string>();

function loadScript(url: string, globalName?: string): Promise<void> {
  if (loadedScripts.has(url)) return Promise.resolve();
  if (globalName && (window as any)[globalName] !== undefined) {
    loadedScripts.add(url);
    return Promise.resolve();
  }
  return new Promise((resolve, reject) => {
    const existing = document.querySelector(`script[src="${url}"]`) as HTMLScriptElement;
    if (existing) {
      if (globalName && (window as any)[globalName] !== undefined) {
        loadedScripts.add(url);
        resolve();
        return;
      }
      const handleLoad = () => {
        loadedScripts.add(url);
        resolve();
        existing.removeEventListener('load', handleLoad);
        existing.removeEventListener('error', handleError);
      };
      const handleError = (err: any) => {
        reject(err);
        existing.removeEventListener('load', handleLoad);
        existing.removeEventListener('error', handleError);
      };
      existing.addEventListener('load', handleLoad);
      existing.addEventListener('error', handleError);
      return;
    }
    const script = document.createElement('script');
    script.src = url;
    script.async = true;
    script.onload = () => {
      loadedScripts.add(url);
      resolve();
    };
    script.onerror = reject;
    document.head.appendChild(script);
  });
}

function isPrivateIP(url: string): boolean {
  try {
    const hostname = new URL(url).hostname;
    if (/^(10|127)\./.test(hostname)) return true;
    if (/^192\.168\./.test(hostname)) return true;
    if (/^172\.(1[6-9]|2[0-9]|3[0-1])\./.test(hostname)) return true;
    if (hostname === 'localhost' || hostname === '127.0.0.1') return true;
    return false;
  } catch {
    return false;
  }
}

export default function TVPlayer({ channel, onPlaybackError }: TVPlayerProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const artRef = useRef<any>(null);
  const [errorInfo, setErrorInfo] = useState<{ title: string; desc: string } | null>(null);
  
  // Keep track of current playback state to support retrying with proxy or fallback url
  const [playbackState, setPlaybackState] = useState<{
    url: string;
    strategy: 'direct' | 'proxy' | 'proxy-stream' | 'drm';
    isFallback: boolean;
    retryWithProxy: boolean;
  }>({
    url: channel.streamUrl,
    strategy: 'direct',
    isFallback: false,
    retryWithProxy: false,
  });

  const preferences = useAppStore((state) => state.preferences);
  const setPreferences = useAppStore((state) => state.setPreferences);
  const addRecentlyWatched = useAppStore((state) => state.addRecentlyWatched);

  // Track global user interaction to bypass autoplay sound restrictions
  const [hasInteracted, setHasInteracted] = useState(false);

  useEffect(() => {
    const handleInteraction = () => {
      setHasInteracted(true);
      document.removeEventListener('click', handleInteraction);
      document.removeEventListener('touchstart', handleInteraction);
    };
    document.addEventListener('click', handleInteraction, { passive: true });
    document.addEventListener('touchstart', handleInteraction, { passive: true });
    return () => {
      document.removeEventListener('click', handleInteraction);
      document.removeEventListener('touchstart', handleInteraction);
    };
  }, []);

  // Update store for recently watched channel
  useEffect(() => {
    if (channel && channel.id) {
      addRecentlyWatched(channel.id);
    }
  }, [channel, addRecentlyWatched]);

  // Reset playback state when channel changes
  useEffect(() => {
    setErrorInfo(null);

    let strategy: 'direct' | 'proxy' | 'proxy-stream' | 'drm' = 'direct';
    const url = channel.streamUrl;

    if (channel.proxy === true) {
      strategy = (url.endsWith('.ts') || url.includes('.ts?')) ? 'proxy-stream' : 'proxy';
    } else if (channel.proxy === false || channel.noProxy === true) {
      strategy = (url.endsWith('.mpd') || url.includes('.mpd?') || channel.drm) ? 'drm' : 'direct';
    } else {
      if (url.endsWith('.mpd') || url.includes('.mpd?') || channel.drm) {
        strategy = 'drm';
      } else if (url.endsWith('.ts') || url.includes('.ts?')) {
        strategy = 'proxy-stream';
      } else if (
        url.includes('cdn.livekhelatv.com') ||
        url.includes('toffeelive.com') ||
        url.includes('cdn.fifalive.click') ||
        url.includes('inproviszon.st') ||
        url.includes('streamhostingcdn.top') ||
        url.startsWith('http://')
      ) {
        strategy = 'proxy';
      }
    }

    setPlaybackState({
      url,
      strategy,
      isFallback: false,
      retryWithProxy: false,
    });
  }, [channel]);

  const handleErrorFallback = () => {
    if (!playbackState.retryWithProxy && playbackState.strategy === 'direct' && !isPrivateIP(channel.streamUrl)) {
      // Direct stream failed. Retry using reverse proxy.
      setPlaybackState((prev) => ({
        ...prev,
        strategy: (channel.streamUrl.endsWith('.ts') || channel.streamUrl.includes('.ts?')) ? 'proxy-stream' : 'proxy',
        retryWithProxy: true,
      }));
      return;
    }

    if (!playbackState.isFallback && channel.fallbackUrl) {
      // Proxy failed or direct private. Retry with fallbackUrl.
      let strat: 'direct' | 'proxy' | 'proxy-stream' | 'drm' = 'direct';
      if (channel.fallbackUrl.includes('.mpd') || channel.fallbackUrl.includes('.mpd?') || channel.drm) {
        strat = 'drm';
      } else if (channel.fallbackUrl.includes('.ts') || channel.fallbackUrl.includes('.ts?')) {
        strat = 'proxy-stream';
      } else if (
        channel.fallbackUrl.includes('cdn.livekhelatv.com') ||
        channel.fallbackUrl.includes('toffeelive.com') ||
        channel.fallbackUrl.includes('cdn.fifalive.click') ||
        channel.fallbackUrl.includes('inproviszon.st') ||
        channel.fallbackUrl.includes('streamhostingcdn.top') ||
        channel.fallbackUrl.startsWith('http://')
      ) {
        strat = 'proxy';
      }

      setPlaybackState({
        url: channel.fallbackUrl,
        strategy: strat,
        isFallback: true,
        retryWithProxy: false,
      });
      return;
    }

    // Both direct & fallback failed, trigger error overlay
    const isDrm = playbackState.url.endsWith('.mpd') || playbackState.url.includes('.mpd?') || !!channel.drm;
    const isPrivate = isPrivateIP(playbackState.url);

    if (isDrm) {
      setErrorInfo({
        title: 'DRM Decryption Error',
        desc: `Failed to decrypt stream for ${channel.name}. This feed requires DRM keys or your browser does not support DRM capabilities.`,
      });
    } else if (isPrivate) {
      setErrorInfo({
        title: 'BDIX Network Restriction',
        desc: `${channel.name} is hosted on a private ISP BDIX server. It is unreachable unless you are on a compatible local network.`,
      });
    } else {
      setErrorInfo({
        title: 'Stream Load Failed',
        desc: `This channel is currently offline or unreachable. Please try again later.`,
      });
    }

    if (onPlaybackError) {
      onPlaybackError(new Error('Playback failed'));
    }
  };

  // Player initialization effect
  useEffect(() => {
    let active = true;
    const container = containerRef.current;
    if (!container) return;

    // Destroy existing player
    if (artRef.current) {
      try {
        const art = artRef.current;
        if (art.shaka) {
          art.shaka.destroy().catch(() => {});
          art.shaka = null;
        }
        if (art.hls) {
          try { art.hls.destroy(); } catch {}
          art.hls = null;
        }
        if (art.mpegtsPlayer) {
          try { art.mpegtsPlayer.destroy(); } catch {}
          art.mpegtsPlayer = null;
        }
        art.destroy(false);
      } catch (e) {
        console.error('Failed to destroy previous player:', e);
      }
      artRef.current = null;
    }

    const { url, strategy } = playbackState;
    const isTs = strategy === 'proxy-stream';
    const isMpd = strategy === 'drm' || url.endsWith('.mpd') || url.includes('.mpd?') || !!channel.drm;

    const CLOUDFLARE_BLOCKED_DOMAINS = ['starhub.pro', 'aiv-cdn.net', 'pv-cdn.net', 'akamaihd.net', 'livekhelatv.com'];
    const isCloudflareBlocked = CLOUDFLARE_BLOCKED_DOMAINS.some(domain => url.includes(domain));
    const proxyBase = (isCloudflareBlocked || !process.env.NEXT_PUBLIC_PROXY_URL)
      ? `${window.location.origin}/proxy`
      : process.env.NEXT_PUBLIC_PROXY_URL;


    const playbackUrl = (strategy === 'proxy' || strategy === 'proxy-stream')
      ? `${proxyBase}${proxyBase.includes('?') ? '&' : '?'}url=${encodeURIComponent(url)}&full=true`
      : url;



    const initPlayer = async () => {
      try {
        if (!active) return;

        const enginePromises: Promise<void>[] = [];
        if (typeof window.Artplayer === 'undefined') {
          enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/artplayer/dist/artplayer.js', 'Artplayer'));
        }

        if (isTs) {
          if (typeof window.mpegts === 'undefined') {
            enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/mpegts.js@1.7.3/dist/mpegts.min.js', 'mpegts'));
          }
        } else if (isMpd) {
          if (typeof window.shaka === 'undefined') {
            enginePromises.push(loadScript('https://cdnjs.cloudflare.com/ajax/libs/shaka-player/4.7.1/shaka-player.compiled.js', 'shaka'));
          }
        } else {
          if (typeof window.Hls === 'undefined') {
            enginePromises.push(loadScript('https://cdn.jsdelivr.net/npm/hls.js@1.5.17/dist/hls.min.js', 'Hls'));
          }
        }

        if (enginePromises.length > 0) {
          await Promise.all(enginePromises);
        }

        if (!active) return;

        // Custom playback functions
        const playM3u8 = (video: HTMLVideoElement, m3u8Url: string, artPlayer: any) => {
          if (window.Hls.isSupported()) {
            if (artPlayer.hls) {
              try { artPlayer.hls.destroy(); } catch {}
              artPlayer.hls = null;
            }
            const hls = new window.Hls({
              enableWorker: true,
              lowLatencyMode: true,
              backBufferLength: 30,
              maxBufferLength: 15,
              maxBufferSize: 30 * 1000 * 1000,
              maxBufferHole: 0.5,
              liveSyncDurationCount: 3,
              manifestLoadingTimeOut: 10000,
              manifestLoadingMaxRetry: 5,
              manifestLoadingRetryDelay: 1000,
              levelLoadingTimeOut: 10000,
              levelLoadingMaxRetry: 5,
              levelLoadingRetryDelay: 1000,
              fragLoadingTimeOut: 20000,
              fragLoadingMaxRetry: 6,
              fragLoadingRetryDelay: 1000,
            });
            hls.loadSource(m3u8Url);
            hls.attachMedia(video);
            artPlayer.hls = hls;

            hls.on(window.Hls.Events.MANIFEST_PARSED, () => {
              const levels = hls.levels;
              if (levels && levels.length > 1) {
                const options = levels.map((level: any, index: number) => ({
                  html: level.height ? `${level.height}p` : `${Math.round(level.bitrate / 1000)}kbps`,
                  level: index,
                }));
                options.unshift({ html: 'Auto', level: -1 });

                try { artPlayer.setting.remove('quality'); } catch {}
                artPlayer.setting.add({
                  name: 'quality',
                  html: 'Quality',
                  width: 150,
                  selector: options,
                  onSelect: (item: any) => {
                    hls.currentLevel = item.level;
                    return item.html;
                  },
                });
              }
            });

            let retryCount = 0;
            hls.on(window.Hls.Events.ERROR, (event: any, data: any) => {
              if (data.fatal) {
                if (data.type === window.Hls.ErrorTypes.NETWORK_ERROR) {
                  retryCount++;
                  if (retryCount > 2) {
                    artPlayer.emit('video:error', data);
                  } else {
                    hls.startLoad();
                  }
                } else if (data.type === window.Hls.ErrorTypes.MEDIA_ERROR) {
                  hls.recoverMediaError();
                } else {
                  artPlayer.emit('video:error', data);
                }
              }
            });
          } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
            video.src = m3u8Url;
          } else {
            artPlayer.emit('video:error', new Error('HLS not supported'));
          }
        };

        const playTs = (video: HTMLVideoElement, tsUrl: string, artPlayer: any) => {
          if (window.mpegts && window.mpegts.getFeatureList().mseLivePlayback) {
            if (artPlayer.mpegtsPlayer) {
              try { artPlayer.mpegtsPlayer.destroy(); } catch {}
              artPlayer.mpegtsPlayer = null;
            }
            const mpegtsPlayer = window.mpegts.createPlayer({
              type: 'mse',
              isLive: true,
              url: tsUrl,
            }, {
              enableWorker: true,
              enableStashBuffer: false,
              stashInitialSize: 128,
              liveBufferLatencyChasing: true,
              liveBufferLatencyChasingOnSeeking: true,
            });
            mpegtsPlayer.attachMediaElement(video);
            mpegtsPlayer.load();
            artPlayer.mpegtsPlayer = mpegtsPlayer;

            mpegtsPlayer.on(window.mpegts.Events.ERROR, (type: any, detail: any, info: any) => {
              artPlayer.emit('video:error', { type, detail, info });
            });
          } else {
            artPlayer.emit('video:error', new Error('TS playback not supported'));
          }
        };

        const playMpd = (video: HTMLVideoElement, mpdUrl: string, artPlayer: any) => {
          window.shaka.polyfill.installAll();
          if (!window.shaka.Player.isBrowserSupported()) {
            artPlayer.emit('video:error', new Error('Shaka Browser not supported'));
            return;
          }

          if (artPlayer.shaka) {
            try { artPlayer.shaka.destroy(); } catch {}
            artPlayer.shaka = null;
          }

          const shakaPlayer = new window.shaka.Player(video);
          artPlayer.shaka = shakaPlayer;

          shakaPlayer.configure({
            streaming: {
              bufferingGoal: 10,
              rebufferingGoal: 2,
              bufferBehind: 30,
              retryParameters: {
                maxAttempts: 5,
                baseDelay: 1000,
                backoffFactor: 2,
              }
            }
          });

          shakaPlayer.addEventListener('error', (event: any) => {
            if (event.detail && event.detail.severity === window.shaka.util.Error.Severity.CRITICAL) {
              artPlayer.emit('video:error', event.detail);
            }
          });

          const drm = channel.drmConfig;
          if (drm && drm.kid && drm.key) {
            try {
              shakaPlayer.configure({
                drm: {
                  clearKeys: {
                    [drm.kid.trim()]: drm.key.trim(),
                  },
                },
              });
            } catch (e) {
              console.error('Shaka DRM ClearKey configuration failed:', e);
            }
          }

          shakaPlayer.load(mpdUrl, null, 'application/dash+xml').then(() => {
            const tracks = shakaPlayer.getVariantTracks();
            if (tracks && tracks.length > 1) {
              tracks.sort((a: any, b: any) => (b.height || 0) - (a.height || 0));
              const seenHeights = new Set();
              const uniqueTracks: any[] = [];
              tracks.forEach((track: any) => {
                if (track.height && !seenHeights.has(track.height)) {
                  seenHeights.add(track.height);
                  uniqueTracks.push(track);
                }
              });

              if (uniqueTracks.length > 1) {
                const options = uniqueTracks.map((track) => ({
                  html: `${track.height}p`,
                  track,
                }));
                options.unshift({ html: 'Auto', track: null });

                try { artPlayer.setting.remove('quality'); } catch {}
                artPlayer.setting.add({
                  name: 'quality',
                  html: 'Quality',
                  width: 150,
                  selector: options,
                  onSelect: (item: any) => {
                    if (item.track === null) {
                      shakaPlayer.configure({ abr: { enabled: true } });
                    } else {
                      shakaPlayer.configure({ abr: { enabled: false } });
                      shakaPlayer.selectVariantTrack(item.track, true);
                    }
                    return item.html;
                  },
                });
              }
            }
          }).catch((err: any) => {
            artPlayer.emit('video:error', err);
          });
        };

        const art = new window.Artplayer({
          container: containerRef.current,
          url: playbackUrl,
          type: isTs ? 'ts' : (isMpd ? 'mpd' : 'm3u8'),
          isLive: true,
          autoplay: true,
          muted: !hasInteracted || preferences.muted,
          volume: preferences.volume,
          pip: true,
          fullscreen: true,
          fullscreenWeb: true,
          autoOrientation: true,
          theme: '#6366f1',
          setting: true,
          playbackRate: true,
          aspectRatio: true,
          hotkey: true,
          lock: true,
          fastForward: true,
          autoPlayback: true,
          customType: {
            m3u8: playM3u8,
            ts: playTs,
            mpd: playMpd,
          },
          settings: [
            {
              html: 'Reload Stream',
              tooltip: 'Reconnect',
              icon: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21.5 2v6h-6M21.34 15.57a10 10 0 1 1-.57-8.38l5.67-5.67"/></svg>',
              onSelect: function () {
                art.url = playbackUrl;
                return 'Reloading...';
              }
            },
            {
              html: 'Proxy Mode',
              tooltip: (strategy === 'proxy' || strategy === 'proxy-stream') ? 'Enabled' : 'Disabled',
              icon: '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>',
              switch: strategy === 'proxy' || strategy === 'proxy-stream',
              onSwitch: function (item: any) {
                const nextSwitch = !item.switch;
                setPlaybackState(prev => ({
                  ...prev,
                  strategy: nextSwitch ? 'proxy' : 'direct'
                }));
                return nextSwitch;
              }
            }
          ]
        });

        artRef.current = art;

        art.on('video:volumechange', () => {
          setPreferences({
            volume: art.volume,
            muted: art.muted,
          });
        });

        art.on('video:error', (err: any) => {
          const videoError = art.video?.error;
          
          // Format shaka player error details if they exist
          let shakaDetails = '';
          if (err && typeof err === 'object' && ('category' in err || 'severity' in err || 'code' in err)) {
            shakaDetails = `\n- Shaka Error Code: ${err.code} (Category: ${err.category}, Severity: ${err.severity})\n- Shaka Data: ${JSON.stringify(err.data)}`;
          }

          const errMsg = `ArtPlayer internal video:error triggered:
- Code: ${videoError?.code || 'N/A'}
- Message: ${videoError?.message || 'N/A'}
- Event/Type: ${err?.type || err?.name || 'N/A'}
- Detail: ${err?.detail ? (typeof err.detail === 'object' ? JSON.stringify(err.detail) : err.detail) : 'N/A'}
- Info: ${err?.info ? (typeof err.info === 'object' ? JSON.stringify(err.info) : err.info) : 'N/A'}${shakaDetails}`;
          
          console.error(errMsg, err);
          handleErrorFallback();
        });

      } catch (err) {
        console.error('ArtPlayer script loading or setup failed:', err);
        handleErrorFallback();
      }
    };

    initPlayer();

    return () => {
      active = false;
      if (artRef.current) {
        try {
          const art = artRef.current;
          if (art.shaka) {
            art.shaka.destroy().catch(() => {});
          }
          if (art.hls) {
            try { art.hls.destroy(); } catch {}
          }
          if (art.mpegtsPlayer) {
            try { art.mpegtsPlayer.destroy(); } catch {}
          }
          art.destroy(false);
        } catch {}
        artRef.current = null;
      }
    };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [playbackState, hasInteracted]);

  const handleRetry = () => {
    setErrorInfo(null);
    setPlaybackState({
      url: channel.streamUrl,
      strategy: channel.proxy === true ? 'proxy' : 'direct',
      isFallback: false,
      retryWithProxy: false,
    });
  };

  return (
    <div className="video-section">
      <div className="video-wrapper">
        <div id="player-container" ref={containerRef} style={{ width: '100%', height: '100%' }} />

        {errorInfo && (
          <div className="error-overlay active" id="errorOverlay" style={{ zIndex: 10 }}>
            <div className="error-card">
              <div className="error-icon">⚠️</div>
              <div className="error-title" id="errorTitle">{errorInfo.title}</div>
              <div className="error-desc" id="errorDesc">{errorInfo.desc}</div>
              <div className="error-actions">
                <button className="btn-error-action secondary" id="btnReloadStream" onClick={handleRetry}>
                  Retry
                </button>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
