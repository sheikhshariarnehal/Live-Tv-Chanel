import { c as createComponent } from './astro-component_M2GAK4VK.mjs';
import 'piccolore';
import { o as createRenderInstruction, k as renderTemplate, p as renderHead } from './entrypoint_LPDa5c6Z.mjs';
import 'clsx';

async function renderScript(result, id) {
  const inlined = result.inlinedScripts.get(id);
  let content = "";
  if (inlined != null) {
    if (inlined) {
      content = `<script type="module">${inlined}</script>`;
    }
  } else {
    const resolved = await result.resolve(id);
    content = `<script type="module" src="${result.userAssetsBase ? (result.base === "/" ? "" : result.base) + result.userAssetsBase : ""}${resolved}"></script>`;
  }
  return createRenderInstruction({ type: "script", id, content });
}

var __freeze = Object.freeze;
var __defProp = Object.defineProperty;
var __template = (cooked, raw) => __freeze(__defProp(cooked, "raw", { value: __freeze(cooked.slice()) }));
var _a;
const $$Index = createComponent(($$result, $$props, $$slots) => {
  return renderTemplate(_a || (_a = __template(['<html lang="en"> <head><meta charset="UTF-8"><meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"><title>📺 Live TV - Professional IPTV Player</title><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"><meta name="description" content="Watch live TV channels in HD quality with our professional IPTV player"><script src="https://cdn.jsdelivr.net/npm/hls.js@latest"><\/script><script src="https://cdn.jsdelivr.net/npm/mpegts.js@1.7.3/dist/mpegts.min.js"><\/script><link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">', '</head> <body> <!-- Header --> <header class="header"> <div class="header-content"> <div class="logo"> <span class="logo-icon">📺</span> <span class="logo-text">Live TV</span> </div> <div class="header-actions"> <button class="btn-icon mobile-menu-toggle" id="mobileMenuBtn" title="Menu"> <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"> <path d="M3 12h18M3 6h18M3 18h18"></path> </svg> </button> </div> </div> </header> <!-- Main Container --> <div class="main-container"> <div class="container"> <!-- Video Player Section --> <div class="video-section"> <div class="video-wrapper"> <video id="player" controls autoplay playsinline></video> <div class="video-overlay" id="videoOverlay"> <div class="loading-spinner"></div> <p class="loading-text">Loading channel...</p> </div> <!-- Dynamic Error Overlay --> <div class="error-overlay" id="errorOverlay"> <div class="error-card"> <div class="error-icon">⚠️</div> <div class="error-title" id="errorTitle">Stream Load Failed</div> <div class="error-desc" id="errorDesc">\nThis stream could not be loaded. If you are accessing this site via Vercel, BDIX local ISP streams (which use private IPs) are unreachable from public servers.\n</div> <div class="error-actions"> <button class="btn-error-action primary" id="btnSwitchPublic">Use Public Streams</button> <button class="btn-error-action secondary" id="btnReloadStream">Retry</button> </div> </div> </div> </div> </div> <!-- Sidebar Section --> <div class="sidebar" id="sidebar"> <!-- Stream Source Selector --> <div class="source-selector"> <button class="source-btn active" id="btnLocalSource" data-source="local">🏠 BDIX (Local)</button> <button class="source-btn" id="btnPublicSource" data-source="public">🌐 Public (Global)</button> </div> <button class="btn-close" id="closeSidebarBtn"> <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"> <path d="M18 6L6 18M6 6l12 12"></path> </svg> </button> <!-- Category Tabs --> <div class="category-tabs" id="categoryTabs"> <!-- Tabs will be dynamically loaded --> </div> <!-- Channel Grid --> <div class="channel-grid" id="channelGrid"> <!-- Channels will be dynamically loaded --> </div> </div> </div> </div> ', " </body> </html>"])), renderHead(), renderScript($$result, "D:/Poject/Live-Tv-Chanel/src/pages/index.astro?astro&type=script&index=0&lang.ts"));
}, "D:/Poject/Live-Tv-Chanel/src/pages/index.astro", void 0);

const $$file = "D:/Poject/Live-Tv-Chanel/src/pages/index.astro";
const $$url = "";

const _page = /*#__PURE__*/Object.freeze(/*#__PURE__*/Object.defineProperty({
  __proto__: null,
  default: $$Index,
  file: $$file,
  url: $$url
}, Symbol.toStringTag, { value: 'Module' }));

const page = () => _page;

export { page };
