/**
 * Vibestream Client-Side Security Script
 * Restricts access to Developer Tools (DevTools) in production environments
 * to protect streaming content and application logic.
 */

(function () {
  // 1. Environment Check
  // Disable security checks on localhost and local networks unless test parameter is active
  const isLocal =
    window.location.hostname === 'localhost' ||
    window.location.hostname === '127.0.0.1' ||
    window.location.hostname.startsWith('192.168.') ||
    window.location.hostname.startsWith('10.') ||
    window.location.hostname.startsWith('172.');
  
  const urlParams = new URLSearchParams(window.location.search);
  const testSecurity = urlParams.has('test_security');
  
  // import.meta.env.PROD is populated by Astro during build time.
  // We run security checks in production (unless local) or if test_security query param is set.
  const isProd = import.meta.env.PROD;
  const shouldRestrict = (isProd && !isLocal) || testSecurity;

  if (!shouldRestrict) {
    console.log('[Vibestream Security] Development mode: Security restrictions disabled.');
    return;
  }

  console.log('[Vibestream Security] Production mode: Security restrictions active.');

  // 2. Prevent Right-Click Context Menu
  document.addEventListener('contextmenu', (e) => {
    e.preventDefault();
  }, false);

  // 3. Block Developer Tools Keyboard Shortcuts
  document.addEventListener('keydown', (e) => {
    // F12 key
    if (e.key === 'F12' || e.keyCode === 123) {
      e.preventDefault();
      return false;
    }

    // Ctrl+Shift+I / Cmd+Option+I (Inspect elements)
    if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'I' || e.key === 'i' || e.keyCode === 73)) {
      e.preventDefault();
      return false;
    }

    // Ctrl+Shift+J / Cmd+Option+J (Console panel)
    if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'J' || e.key === 'j' || e.keyCode === 74)) {
      e.preventDefault();
      return false;
    }

    // Ctrl+Shift+C / Cmd+Option+C (Element selector)
    if ((e.ctrlKey || e.metaKey) && e.shiftKey && (e.key === 'C' || e.key === 'c' || e.keyCode === 67)) {
      e.preventDefault();
      return false;
    }

    // Ctrl+U / Cmd+Option+U (View Page Source)
    if ((e.ctrlKey || e.metaKey) && (e.key === 'U' || e.key === 'u' || e.keyCode === 85)) {
      e.preventDefault();
      return false;
    }
  }, false);

  // 4. DevTools Active Detection & DOM Replacement
  let accessDeniedTriggered = false;

  function triggerAccessDenied() {
    if (accessDeniedTriggered) return;
    accessDeniedTriggered = true;

    // Clear intervals to stop further background processes
    clearInterval(detectionInterval);

    // Stop page loading and active streams immediately
    window.stop();

    // Replace page content with premium Access Denied UI
    document.documentElement.innerHTML = `
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Access Denied | Vibestream Security</title>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <style>
          * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
          }
          
          body {
            background-color: #09090b;
            margin: 0;
            padding: 0;
            overflow: hidden;
          }

          .access-denied-screen {
            position: fixed;
            inset: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #09090b;
            background-image: 
              radial-gradient(circle at center, rgba(239, 68, 68, 0.08) 0%, transparent 65%),
              linear-gradient(rgba(255, 255, 255, 0.015) 1px, transparent 1px),
              linear-gradient(90deg, rgba(255, 255, 255, 0.015) 1px, transparent 1px);
            background-size: 100% 100%, 24px 24px, 24px 24px;
            font-family: 'Inter', system-ui, -apple-system, sans-serif;
            color: #f4f4f5;
            z-index: 2147483647;
            padding: 1.5rem;
          }

          .security-card {
            max-width: 440px;
            width: 100%;
            background: rgba(18, 18, 20, 0.75);
            border: 1px solid rgba(239, 68, 68, 0.2);
            border-radius: 24px;
            padding: 3rem 2.25rem;
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            box-shadow: 
              0 24px 60px rgba(0, 0, 0, 0.6),
              0 0 50px rgba(239, 68, 68, 0.04);
            text-align: center;
            animation: cardAppear 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
          }

          @keyframes cardAppear {
            from {
              transform: translateY(30px);
              opacity: 0;
            }
            to {
              transform: translateY(0);
              opacity: 1;
            }
          }

          .security-icon {
            position: relative;
            width: 80px;
            height: 80px;
            margin: 0 auto 1.75rem auto;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ef4444;
          }

          .shield-svg {
            width: 52px;
            height: 52px;
            filter: drop-shadow(0 0 12px rgba(239, 68, 68, 0.4));
            z-index: 2;
          }

          .pulse-ring {
            position: absolute;
            inset: 0;
            border: 2px solid rgba(239, 68, 68, 0.25);
            border-radius: 50%;
            animation: pulse 2.2s cubic-bezier(0.24, 0, 0.38, 1) infinite;
            z-index: 1;
          }

          @keyframes pulse {
            0% {
              transform: scale(0.85);
              opacity: 0.6;
            }
            50% {
              opacity: 0.8;
            }
            100% {
              transform: scale(1.35);
              opacity: 0;
            }
          }

          .security-title {
            font-size: 1.85rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            background: linear-gradient(135deg, #ff6b6b 0%, #ef4444 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0 0 0.5rem 0;
          }

          .security-subtitle {
            font-size: 1.05rem;
            font-weight: 600;
            color: #a1a1aa;
            margin: 0 0 1.75rem 0;
          }

          .security-text {
            font-size: 0.9rem;
            line-height: 1.6;
            color: #71717a;
            margin: 0 0 1.75rem 0;
          }

          .security-instructions {
            background: rgba(239, 68, 68, 0.02);
            border: 1px solid rgba(239, 68, 68, 0.08);
            border-radius: 14px;
            padding: 1.125rem;
            margin-bottom: 2.25rem;
            text-align: left;
          }

          .instruction-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.85rem;
            color: #a1a1aa;
            margin-bottom: 0.625rem;
          }

          .instruction-item:last-child {
            margin-bottom: 0;
          }

          .bullet {
            width: 6px;
            height: 6px;
            background-color: #ef4444;
            border-radius: 50%;
            box-shadow: 0 0 6px #ef4444;
          }

          .btn-refresh {
            width: 100%;
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 0.95rem;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            box-shadow: 0 4px 18px rgba(239, 68, 68, 0.25);
            transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
          }

          .btn-refresh:hover {
            transform: translateY(-1.5px);
            box-shadow: 0 6px 22px rgba(239, 68, 68, 0.35);
          }

          .btn-refresh:active {
            transform: translateY(0.5px);
          }
        </style>
      </head>
      <body>
        <div class="access-denied-screen">
          <div class="security-card">
            <div class="security-icon">
              <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="shield-svg">
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                <path d="M12 8v4"/>
                <path d="M12 16h.01"/>
              </svg>
              <div class="pulse-ring"></div>
            </div>
            <h1 class="security-title">ACCESS DENIED</h1>
            <h2 class="security-subtitle">Developer Tools Restricted</h2>
            <p class="security-text">
              To protect stream sources and ensure content security, access to developer tools and page inspection is disabled on this platform.
            </p>
            <div class="security-instructions">
              <div class="instruction-item">
                <span class="bullet"></span> Close the Developer Tools console.
              </div>
              <div class="instruction-item">
                <span class="bullet"></span> Refresh the web page to restore access.
              </div>
            </div>
            <button class="btn-refresh" id="btnRefresh">Refresh Page</button>
          </div>
        </div>
      </body>
    `;

    // Hook the refresh button event
    document.getElementById('btnRefresh').addEventListener('click', () => {
      // Reload without the testing parameter to return to normal site if desired
      if (testSecurity) {
        window.location.href = window.location.pathname;
      } else {
        window.location.reload();
      }
    });

    throw new Error('Script execution halted due to security restriction.');
  }

  // 5. DevTools Detection Logic

  // A. Timing / Debugger based check
  // This is highly robust. When DevTools is open, the debugger pauses execution.
  // If the pause duration exceeds 100ms, it indicates DevTools is active.
  const checkDebugger = () => {
    const startTime = performance.now();
    debugger;
    const endTime = performance.now();
    if (endTime - startTime > 100) {
      triggerAccessDenied();
    }
  };

  // B. Window Size dock detection
  // Detects if DevTools is docked on the side/bottom of the browser window.
  // Excludes mobile user-agents to prevent false-positives from mobile browser toolbars.
  const checkSize = () => {
    const threshold = 160;
    const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
    if (!isMobile) {
      const widthDiff = window.outerWidth - window.innerWidth;
      const heightDiff = window.outerHeight - window.innerHeight;
      if (widthDiff > threshold || heightDiff > threshold) {
        triggerAccessDenied();
      }
    }
  };

  // Run initial checks
  checkDebugger();
  checkSize();

  // Run checks repeatedly in background
  const detectionInterval = setInterval(() => {
    checkDebugger();
    checkSize();
  }, 1000);

})();
