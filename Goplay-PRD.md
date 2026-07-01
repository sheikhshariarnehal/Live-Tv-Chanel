# Product Requirements Document: Goplay

**Document version:** 1.0
**Last updated:** June 30, 2026
**Platform:** Android (Flutter)
**Status:** Draft

---

## 1. Overview

### 1.1 Product Summary

Goplay is a modern IPTV Android application focused on live sports and TV channels. It combines a polished Material 3 interface with a minimal-cost, highly scalable backend. Unlike conventional IPTV apps that present users with a flat list of channels, Goplay is event-first: the app's primary job is to surface what's live or about to start right now, and channels exist as the means to watch those events rather than the main navigational unit.

### 1.2 Problem Statement

Most IPTV apps are channel directories. Users who care about a specific match or event have to know which channel is airing it and hunt for it manually. There is no "what's on today" experience, no countdown to kickoff, and no lightweight way to browse upcoming fixtures across sports. Goplay solves this by making events, not channels, the entry point.

### 1.3 Goals

- Deliver an app that starts in under 2 seconds and feels instant to navigate.
- Provide a beautiful, modern Material 3 UI optimized for quick access to live matches.
- Route zero video traffic through Goplay's own servers; all playback is direct from the IPTV provider via an on-device proxy.
- Support 100,000+ users on a thin, inexpensive backend (static metadata + a small auth/profile service).
- Keep channel and event metadata fresh via versioned cloud updates with local caching for offline resilience.

### 1.4 Non-Goals

- Goplay does not host, transcode, or relay video streams.
- Goplay does not aggregate or scrape IPTV sources automatically; channel and event data is curated through the admin dashboard.
- Goplay is not, at this stage, a social or chat product; no comments, chat, or community features are in scope.
- Android TV, Chromecast, and multi-view are explicitly deferred to a future phase (see Section 16).

---

## 2. Target Users

- Sports fans who want a single place to see what's live or starting soon across football, cricket, tennis, and other sports.
- Casual IPTV viewers who want quick access to a curated list of TV channels by category or country.
- Users in regions (e.g., Bangladesh, South Asia) where channel bundles include a mix of local and international sports and entertainment channels.

---

## 3. Objectives & Success Metrics

| Objective | Target | How it's measured |
|---|---|---|
| Fast cold start | App startup under 2 seconds | Time from launch to interactive Home screen |
| Cached channel load | Channel list loads in under 1 second | Time to render Channels screen from local cache |
| Player startup | Stream begins playing in under 3 seconds | Time from tap to first frame |
| Memory footprint | Under 200 MB during normal use | Profiled on a mid-tier Android device |
| Zero server video cost | 0% of video traffic through Goplay infrastructure | Backend bandwidth monitoring |
| Scale | Support 100,000+ users | Load testing against Cloudflare R2 + Supabase usage tiers |

---

## 4. Tech Stack

### 4.1 Frontend

- **Framework:** Flutter
- **Design system:** Material 3
- **State management:** Riverpod
- **Routing:** Go Router
- **Networking:** Dio
- **Local storage:** Hive / Isar (offline cache for channels, events, favorites)
- **Video playback:** media_kit (recommended), with better_player as a fallback option
- **Image/asset caching:** flutter_cache_manager

### 4.2 Backend

**Cloudflare R2** — static metadata and media assets, serving:
- `version.json`
- `channels.json`
- `events.json`
- `categories.json`
- `logos/`
- `banners/`
- `flags/`

**Supabase** — used strictly for user-account-related functionality:
- Authentication(not need now)
- User profile
- Favorites (sync layer)
- Watch history (sync layer)
- Push notification tokens
- Admin dashboard backing store
- Announcements

Explicitly **not** handled by Supabase: video streaming, channel/event metadata (these live in R2).

### 4.3 Architecture Diagram (textual)

```
Flutter App
   │
   ├──► Cloudflare R2
   │       ├── channels.json
   │       ├── events.json
   │       ├── version.json
   │       └── images (logos / banners / flags)
   │
   ├──► Supabase
   │       ├── login / auth
   │       ├── favorites
   │       ├── watch history
   │       └── notifications
   │
   └──► IPTV Provider
           └── M3U stream (direct playback, on-device proxy for headers/referer)
```

This separation keeps video bandwidth entirely off Goplay's infrastructure: the app fetches lightweight JSON metadata from R2, manages user data through Supabase, and streams video directly from the provider, with a local on-device proxy handling custom headers (referer, user-agent) that some IPTV streams require.

---

## 5. Information Architecture

### 5.1 Bottom Navigation

Three tabs only, kept deliberately minimal:

1. **Home** — event-first dashboard
2. **Channels** — full channel directory
3. **Upcoming** — future events grouped by date

---

## 6. Feature Requirements

### 6.1 Home Screen

The Home screen is the app's centerpiece and default landing screen. Its purpose is to answer "what's on right now and today" before the user has to think about channels.

**Sections (top to bottom):**

1. **Hero Banner**
   - Rotating top banner promoting a featured live or upcoming event (e.g., "FIFA Club World Cup — Live Today — Watch Now").
   - Tapping the banner deep-links into the relevant event/player.

2. **Ongoing Matches**
   - Horizontally scrolling cards for matches currently live or starting soon.
   - Each card displays: tournament/league, team flags, team names, match status, and score/time context.
   - If the match is upcoming: a countdown timer (e.g., "Starts in 02:17:41").
   - If the match is live: a "LIVE" badge plus elapsed time (e.g., "01:22").

3. **Today's Schedule**
   - Events grouped by sport (Football, Cricket, Tennis, etc.), each showing a short list of matches for that sport today.

4. **Trending Channels**
   - Horizontal slider of popular channels (e.g., TSports, Sony Sports, Star Sports, ESPN, Sky Sports) for users who want to jump straight to a channel.

5. **Recently Watched**
   - "Continue watching" row sourced from local watch history (synced with Supabase when authenticated).

6. **Announcements**
   - Compact card surfacing operational messages (e.g., scheduled maintenance windows) sourced from Supabase.

### 6.2 Channels Screen

Purpose: browse the full channel catalog independent of live events.

**Components:**

- **Search bar** at the top ("Search channels...").
- **Category chips** (horizontally scrollable, single or multi-select): All, Sports, News, Entertainment, Movies, Kids, Music, Religious, Bangladesh, India, International.
- **Channel cards** showing: logo, name, category, quality badge (HD), favorite toggle, and a live indicator. Tapping a card opens the player.
- **Filters:** quality (HD/4K), country, language, favorites-only, and recently-added.

### 6.3 Upcoming Screen

Purpose: a forward-looking calendar of fixtures, separate from the Home screen's "happening now" focus.

**Structure:**

- Events grouped by date bucket: Today, Tomorrow, Next 7 Days.
- Each event card shows: sport/tournament, both teams with flags, scheduled date/time.
- Per-event actions: Set Reminder, Add to Calendar, View Channels (jumps to the channel(s) broadcasting that event).

### 6.4 Video Player

**Required capabilities:**

- Fullscreen playback with automatic landscape orientation on entering fullscreen.
- Lockable on-screen controls.
- Gesture controls: brightness (vertical swipe, left side), volume (vertical swipe, right side), seek (horizontal swipe, where applicable to the stream type).
- Retry and auto-reconnect on stream drop or buffering failure.
- Visible buffering indicator.
- Stream quality selection (where the source provides multiple renditions).
- In-player channel switching without leaving the player.
- Favorite toggle accessible from the player.
- Picture-in-Picture (PiP) support.
- Chromecast support is deferred to a future release (see Section 16).
- **DRM playback support:**
  - ClearKey DRM for DASH CENC-encrypted streams (kid/key embedded in channel metadata, no license server required).
  - Widevine DRM for license-server-based streams (future — requires ExoPlayer native integration).
  - Visual DRM indicator (lock badge) in player controls for DRM-protected channels.

### 6.5 Favorites

- Users can favorite channels and events.
- Stored locally for instant access and offline availability.
- Synced to Supabase when the user is authenticated, enabling favorites to persist across devices.

### 6.6 Watch History

- The app records the last-watched channel/event per user.
- Surfaces as a "Resume" affordance on Home (Recently Watched section).

### 6.7 Search

Global search covers:

- Channel name
- Tournament/league name
- Team name
- Country

---

## 7. Data Model

### 7.1 `channels.json`

```json
{
  "id": "tsports",
  "name": "TSports",
  "logo": "logo.png",
  "category": "Sports",
  "country": "Bangladesh",
  "language": "Bangla",
  "isLive": true,
  "streamUrl": "...",
  "headers": {
    "referer": "...",
    "user-agent": "..."
  },
  "proxy": false,
  "drm": null
}
```

**DRM Configuration (`drm` field):**

- **No DRM:** `"drm": null`
- **ClearKey (embedded keys — no license server):**
```json
{
  "drm": {
    "type": "clearkey",
    "kid": "f6564ec2aee819046328a0e153be574d",
    "key": "ff46a8a1031eb27ef22576a077c98ab7"
  }
}
```
- **Widevine (license server — future):**
```json
{
  "drm": {
    "type": "widevine",
    "licenseUrl": "https://license.provider.com/widevine",
    "headers": {
      "Authorization": "Bearer ..."
    }
  }
}
```

### 7.2 `events.json`

```json
{
  "id": "fifa001",
  "sport": "Football",
  "league": "FIFA Club World Cup",
  "homeTeam": {
    "name": "Manchester City",
    "flag": "..."
  },
  "awayTeam": {
    "name": "Real Madrid",
    "flag": "..."
  },
  "startTime": "2026-06-30T18:30:00Z",
  "status": "upcoming",
  "channels": [
    "tsports",
    "sony1"
  ]
}
```

### 7.3 `version.json`

```json
{
  "version": 156,
  "channels": 92,
  "events": 25,
  "updatedAt": "2026-06-30T18:00:00Z"
}
```

The app polls or checks `version.json` on launch/foreground. If the version number has incremented since the last sync, the app downloads only the updated metadata files rather than re-fetching everything, minimizing bandwidth and keeping startup fast.

---

## 8. Admin Dashboard

A web-based panel for content operators (not end users) to manage catalog data.

**Functions:**

- Add / Edit / Delete Channel
- Add / Edit Match (event)
- Upload Logos, Flags, Banners
- Publish Update

**Publish pipeline:**

```
Generate channels.json
        ↓
Generate events.json
        ↓
Update version.json
        ↓
Upload to Cloudflare R2
        ↓
Flutter app detects new version
        ↓
Downloads only updated metadata
```

This pipeline is the backbone of Goplay's low-cost scalability: content updates are static-file publishes, not API calls under load, so the cost of serving 100,000+ users stays close to flat.

---

## 9. Non-Functional Requirements

### 9.1 Performance Goals

| Metric | Target |
|---|---|
| App startup | Under 2 seconds |
| Channel list load (cached) | Under 1 second |
| Player startup | Under 3 seconds |
| Memory usage | Under 200 MB |
| Concurrent user support | 100,000+ (via static metadata architecture) |
| Video traffic through Goplay's server | 0% (direct playback via on-device proxy) |

### 9.2 Offline Behavior

- Channel and event metadata is cached locally (Hive/Isar) so the app remains browsable without connectivity.
- Favorites and watch history are available offline and sync to Supabase once connectivity is restored.

### 9.3 Scalability & Cost

- Video is never proxied or transcoded by Goplay's infrastructure — it streams directly from the IPTV provider to the device.
- Metadata is served as static JSON from Cloudflare R2, which scales horizontally at near-zero marginal cost.
- Supabase is scoped narrowly to auth and small user-data tables, keeping its load light regardless of catalog size.

---

## 10. Design Principles

1. **Sports-first experience.** Live and upcoming events are the primary focus; channels exist to serve those events, not the other way around.
2. **Minimal infrastructure.** Cloudflare R2 serves static metadata, Supabase manages user data, and all video streams are fetched directly from the IPTV provider using an on-device proxy.
3. **Modern UI.** Material 3 with smooth animations, large touch targets, and an experience optimized for quick access to live matches rather than navigating long channel lists.

---

## 11. Future Features (Out of Scope for v1)

- Android TV support
- Chromecast
- Multi-view (watch 2–4 channels simultaneously)
- EPG (Electronic Program Guide)
- Live scores
- Match statistics
- AI-powered channel recommendations
- Multiple stream sources with automatic failover
- Dark/Light theme toggle
- Multi-language support (English / Bangla / Arabic)
- Push notifications for favorite teams and upcoming matches

---

## 12. Open Questions

- What is the source of truth for live match status/score updates feeding `events.json` (manual admin entry vs. a future sports-data integration)?
- What is the expected refresh cadence for `version.json` checks — on every app foreground, on a timer, or push-triggered?
- What IPTV provider(s) will supply `streamUrl` and required headers, and do their terms of service permit this distribution model?
- What is the retention policy for watch history in Supabase?
