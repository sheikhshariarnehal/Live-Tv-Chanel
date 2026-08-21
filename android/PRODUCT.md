# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

Primary: sports fans in South Asia — especially Bangladesh — who follow live football, cricket, tennis and similar events across a mix of local and international channels, and want one place to see what is live or starting soon without already knowing which channel carries it.

Secondary: casual IPTV viewers who want quick, curated access to live TV channels by category (Sports, News, Entertainment, Movies, Kids, Music, Religious) and by country/language.

Situation and job: typically on a mid-tier Android phone, often around match time at home or on the go. The job is "get me to the match — or the channel — that is on right now, fast," with minimal browsing.

## Product Purpose

GoPlay is an event-first IPTV app for Android. Where conventional IPTV apps present a flat channel directory, GoPlay's primary job is to surface what is live or about to start right now; channels exist as the means to watch those events, not the main navigational unit. It also serves as a curated live-TV channel browser and (planned) a lightweight movies catalog.

Success means the user reaches a playing stream for the event or channel they want within seconds, with the app feeling instant and the "what's on today" answer available before they have to think about channels. Internal performance targets: cold start under 2s, cached channel list under 1s, stream first frame under 3s, under 200 MB memory on a mid-tier device.

## Positioning

Two claims a neighboring IPTV app could not truthfully copy without rebuilding around them:

1. **Event-first navigation.** Live and upcoming matches are the entry point and organizing principle; the channel list is secondary. Most competitors are channel directories that force users to hunt for the match manually.
2. **Zero-video-cost architecture.** GoPlay never hosts, transcodes, or relays video. Lightweight metadata is served as static JSON from Cloudflare R2, user data lives in a narrowly scoped Supabase, and video streams directly from the IPTV provider to the device (native header injection, with per-stream IP whitelisting / proxy handling only where a CDN requires it). A thin, near-flat-cost backend is therefore designed to support 100,000+ users.

## Operating Context

- **Distribution:** direct-download APK / sideload. The app owns its own update experience through a self-hosted `update.json` (cdn.ntechbd.app) and an in-app `UpdateHandler`; there is no dependency on Google Play for delivery or updates.
- **Content operations:** a separate web admin dashboard lets operators add/edit channels, matches (events), and movies and upload logos, flags, and banners. Publishing regenerates static JSON (`channels.json`, `events.json`, `categories.json`, `version.json`, plus movie data) and uploads it to Cloudflare R2. Catalog data is operator-curated, never auto-scraped by the app.
- **Sync ritual:** on launch/foreground the app checks `version.json`; when a version number increments it downloads only the changed metadata files, then renders instantly from the local Hive cache. Related repository components: `backend/`, `chanels Scraper/`, `iptv_checker/`, `Test Server/`, and `Android App Landing Page/` (a separate web marketing surface).
- **Primary surfaces (bottom navigation):** Home (event-first dashboard — hero banner, ongoing/soon matches with LIVE badges and countdowns, today's schedule grouped by sport, trending channels, recently watched, announcements), Channels (search + category chips + filters over the full catalog), Upcoming (fixtures grouped Today / Tomorrow / Next 7 Days with reminders and "view channels"). A Movies tab is specced and planned as a fourth destination.
- **Playback scene:** fullscreen landscape video with lockable controls, gesture brightness/volume/seek, buffering with retry and auto-reconnect, quality selection, in-player channel switching, Picture-in-Picture, and a DRM lock indicator.

## Capabilities and Constraints

Confirmed capabilities:

- Live-TV channel browsing (categories: Sports, News, Entertainment, Movies, Kids, Music, Religious, plus country buckets such as Bangladesh, India, International), favorites, watch history / "continue watching", global search (channel, tournament/league, team, country), and reminders / add-to-calendar for upcoming events.
- Video player: ClearKey DRM today; Widevine planned; PiP; gesture controls; auto-reconnect.
- Offline-first: channels, events, categories, favorites, and watch history cache locally (Hive) and stay browsable without connectivity; user data syncs to Supabase once accounts are enabled.

Technical constraints and stack (already fixed by the codebase):

- Flutter + Material 3, dark theme only today. Riverpod (state), GoRouter (routing), Dio (networking), Hive (local cache), google_fonts/Inter, cached_network_image, wakelock_plus, permission_handler, supabase_flutter.
- Backend split: Cloudflare R2 for static metadata and media assets; Supabase strictly for account-scoped data (profile, favorites sync, watch history sync, push tokens, announcements, admin store). R2 never serves user data; Supabase never serves video or catalog metadata.
- System text scaling is intentionally clamped (1.0–1.3) because unclamped scaling overflowed fixed-height cards such as the channel grid.

Terminology: "event-first", on-device proxy / native header injection, IP whitelisting (e.g. Toffee / kkx4 CDNs), ClearKey vs Widevine DRM, `version.json` sync.

Explicitly undecided or in-flight (do not invent answers):

- Accounts/auth are deferred ("not needed now"); favorites and history are local-first, with the Supabase sync layer dormant until accounts ship.
- The Movies module (~24,000 titles imported hourly from an external M3U source into Supabase; the app reads Supabase-derived data only and never parses M3U) is specified but not yet implemented. It adds a Movies nav tab and a `movies_version` to the sync system.
- The player engine is migrating from `media_kit` toward native Media3/ExoPlayer (via `better_player` or a custom platform view) to gain Widevine and shrink the APK; not yet done.
- Open PRD questions: source of truth for live match status/scores (manual admin entry vs a future sports-data feed); `version.json` check cadence; which IPTV provider(s) supply streams and whether their terms permit this distribution model; Supabase watch-history retention policy.
- Deferred (out of scope now): Android TV, Chromecast, multi-view, EPG, live scores/stats, recommendations, multi-source failover, light-theme toggle, multi-language UI, push notifications.

## Brand Commitments

- **Name:** GoPlay (canonical, user-confirmed). "GoLive" in `analysis_and_plan.md` is a stale reference, not the product name.
- **Assets:** wordmark/logo at `android/assets/images/logo.png`; app icon at `android/icon.png`; bundled UI typeface is Inter (weights 400–900).
- An implemented dark Material 3 visual identity already exists (near-black canvas, single teal accent) in `android/lib/core/theme.dart`. It is recorded here only as incumbent evidence; its aesthetic direction is owned by DESIGN.md through `document` / `new-work`, not re-decided in this product record.
- No tagline, voice charter, or personality has been explicitly established. Future copy work should confirm voice rather than assume one.

## Evidence on Hand

- Product docs: `Goplay-PRD.md` (v1.0), `GoPlay Movies Module.md` (module spec), `analysis_and_plan.md` (Sportzfy reference-app teardown plus a player/proxy optimization plan).
- Working software: a mature implemented app (splash, home, channels, upcoming, player, search, settings) and a released build (`goplay-release.apk`).
- Marketing: an existing landing page under `Android App Landing Page/` (`goplay-landing.html`) — a separate web surface.
- Live infrastructure references in code: a Supabase project URL and anon key, and an update feed at `cdn.ntechbd.app`.
- Absences future work must not fabricate: no testimonials, customer names, user counts, benchmarks, pricing, licensing terms, or confirmed IPTV-provider agreements exist yet. The 100,000+ figure is a scale *target*, not a measured user count. Do not present any of these as real.

## Product Principles

1. **Events over channels.** What is live or starting now is the organizing principle; the channel list serves events, never the reverse.
2. **Zero video cost.** Never host, transcode, or relay video; keep bandwidth off GoPlay infrastructure so scale stays near-flat cost.
3. **Instant and offline-resilient.** Load from local cache first and sync deltas in the background; stay fast and browsable on a mid-tier phone with poor connectivity.
4. **Curated, not scraped.** Catalog data is operator-curated and published as static, versioned metadata; the app is a reader, not a scraper.
5. **Quick access on the phone in hand.** Large touch targets and minimal navigation, optimized for reaching a stream in seconds rather than deep browsing.

## Accessibility & Inclusion

- Regional inclusion: content spans Bangla, Hindi, and English channels and teams for a South Asian audience; the app UI is English today, with multi-language UI explicitly deferred.
- Large touch targets and quick-access layouts are a stated design principle.
- System text scaling is supported but clamped to 1.0–1.3 to prevent fixed-height layout overflow; future layout work should aim to raise this ceiling rather than depend on the clamp.
- Ships dark-only today; a light theme exists in code but is not shipped, so contrast and color decisions currently target the dark surface.
