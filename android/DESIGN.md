---
name: GoPlay
description: An event-first IPTV app — a dark broadcast control room where one teal signal marks what's live.
colors:
  signal-teal: "#00ADB5"
  signal-teal-deep: "#008A91"
  signal-teal-bright: "#4DD8DE"
  on-signal: "#00282B"
  teal-container: "#00363A"
  on-teal-container: "#7FE9EF"
  mint: "#80CBC4"
  live-red: "#FF3B30"
  error-red: "#FF453A"
  success-green: "#32D74B"
  warning-amber: "#FFB020"
  quality-4k-blue: "#3B82F6"
  canvas: "#0E0F11"
  canvas-deepest: "#08090A"
  surface-low: "#141519"
  surface: "#1B1C20"
  surface-high: "#232428"
  surface-highest: "#2C2D31"
  text-primary: "#F5F5F7"
  text-secondary: "#9A9CA8"
  text-muted: "#6B6D78"
  hairline: "rgba(255,255,255,0.12)"
  divider: "rgba(255,255,255,0.08)"
typography:
  display:
    fontFamily: "Inter, sans-serif"
    fontSize: "57px"
    fontWeight: 800
    lineHeight: 1.12
    letterSpacing: "-1px"
  headline:
    fontFamily: "Inter, sans-serif"
    fontSize: "32px"
    fontWeight: 800
    lineHeight: 1.25
    letterSpacing: "-0.5px"
  title:
    fontFamily: "Inter, sans-serif"
    fontSize: "22px"
    fontWeight: 700
    lineHeight: 1.27
    letterSpacing: "-0.2px"
  body:
    fontFamily: "Inter, sans-serif"
    fontSize: "14px"
    fontWeight: 400
    lineHeight: 1.4
    letterSpacing: "normal"
  label:
    fontFamily: "Inter, sans-serif"
    fontSize: "12px"
    fontWeight: 600
    lineHeight: 1.33
    letterSpacing: "0.5px"
rounded:
  xs: "4px"
  sm: "6px"
  md: "8px"
  lg: "12px"
  input: "14px"
  xl: "16px"
  "2xl": "20px"
  "3xl": "24px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "20px"
  gutter: "16px"
components:
  button-primary:
    backgroundColor: "{colors.signal-teal}"
    textColor: "{colors.on-signal}"
    rounded: "{rounded.lg}"
    padding: "14px 24px"
  watch-cta:
    backgroundColor: "{colors.signal-teal}"
    textColor: "#17181C"
    rounded: "{rounded.md}"
    height: "32px"
    padding: "0 12px"
  chip-filter-selected:
    backgroundColor: "{colors.text-primary}"
    textColor: "#0F0F0F"
    rounded: "{rounded.md}"
    padding: "5px 12px"
  chip-filter-unselected:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.md}"
    padding: "5px 12px"
  channel-card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.md}"
    padding: "8px"
  event-card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    padding: "7px 12px"
  input-field:
    backgroundColor: "{colors.surface-high}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.input}"
    padding: "14px 16px"
  live-badge:
    backgroundColor: "{colors.live-red}"
    textColor: "#FFFFFF"
    rounded: "{rounded.sm}"
    padding: "3px 8px"
  nav-item-active:
    textColor: "{colors.signal-teal}"
---

# Design System: GoPlay

## Overview

**Creative North Star: "The Broadcast Control Room"**

GoPlay looks like a darkened match-director's gallery. The room is near-black and neutral on purpose, so the only thing that glows is the signal: a single teal that marks what is live, active, selected, or worth tapping. Where a conventional IPTV app throws a wall of logos at you, GoPlay keeps the surfaces calm and matte, then uses light and color the way a control room does — sparingly, and only to tell you where to look. Red is the on-air tally light: it means one thing, LIVE, and nothing else ever borrows it.

The system is dark, quiet, and signal-driven. Color equals information, never decoration. Density is high but never loud: content sits on a five-step tonal ladder of near-black surfaces separated by hairline borders rather than boxes and shadows. Components feel precise and broadcast-grade — hairline-bordered, tightly padded, restrained — like instruments on a mixing desk rather than consumer toys. Typography does the labeling work: metadata (leagues, statuses, section titles) is set in tracked uppercase Inter, so the interface reads like a fixtures board even before you parse the words.

The palette is deliberately committed, not adaptive. GoPlay rejects wallpaper-tinted Material You dynamic color: the canvas is a fixed neutral near-black and the accent is one owned brand teal, every device, every time. Depth is flat by default, with exactly one soft ambient shadow reserved for the two things that genuinely float — the hero carousel and the match cards — plus a teal glow reserved for the single primary action, WATCH.

**Key Characteristics:**
- Near-black neutral canvas (`#0E0F11`) with a five-step tonal surface ladder, not shadows, for depth.
- One accent: Signal Teal (`#00ADB5`), used only for live/active/selected/primary.
- Red (`#FF3B30`) is reserved exclusively for LIVE status.
- Tracked uppercase Inter for all metadata labels; hairline borders everywhere.
- Flat-by-default; one soft ambient shadow only on the hero and match cards.
- Committed brand color — no dynamic/Material You tinting.

## Colors

A neutral near-black stage lit by a single teal signal, with red held back for one job only.

### Primary
- **Signal Teal** (`#00ADB5`): The one voice. Marks live-now indicators, countdowns, the selected nav destination, primary/filled buttons, the WATCH CTA, focus borders, and active page dots. Its scarcity is the point.
- **Signal Teal Deep** (`#008A91`): The pressed/gradient-end and light-theme primary. Pairs with Signal Teal in the primary gradient.
- **Signal Teal Bright** (`#4DD8DE`): Rare highlight tint for emphasis on dark surfaces.
- **On-Signal** (`#00282B`): Near-black teal used for text/icons sitting on a teal fill, so filled buttons keep AA contrast without pure black.
- **Teal Container / On-Teal Container** (`#00363A` / `#7FE9EF`): Low-emphasis teal chips and their content.

### Secondary
- **Mint** (`#80CBC4`): Secondary accent for supporting emphasis; used sparingly and never in competition with Signal Teal.

### Status & Utility
- **Live Red** (`#FF3B30`): LIVE only — the pulsing badge, the live event card's left accent bar, and the favorited-channel heart. Never a generic error or decoration.
- **Error Red** (`#FF453A`): Destructive/error states and connection failures (a distinct, slightly warmer red from Live Red).
- **Success Green** (`#32D74B`): Positive confirmations.
- **Warning Amber** (`#FFB020`): Cautions and warning announcement tiles.
- **Quality 4K Blue** (`#3B82F6`): The 4K quality badge only; HD badges use Signal Teal.

### Neutral
- **Canvas** (`#0E0F11`): App background — a neutral near-black with no blue cast, so teal is the only chroma competing for attention.
- **Canvas Deepest** (`#08090A`): The lowest well (behind the lowest surfaces).
- **Surface Low** (`#141519`): Navigation bar / rail and bottom-sheet grounds.
- **Surface** (`#1B1C20`): The default card and container fill.
- **Surface High** (`#232428`): Elevated fills — input fields, chips, popup menus, dialogs.
- **Surface Highest** (`#2C2D31`): Snackbars, tooltips, the highest tonal step.
- **Text Primary** (`#F5F5F7`): Headings and primary content; also the fill of the *selected* sport-filter chip.
- **Text Secondary** (`#9A9CA8`): Body copy, secondary labels, inactive icons.
- **Text Muted** (`#6B6D78`): Tertiary text, placeholders, unselected nav labels.
- **Hairline** (`rgba(255,255,255,0.12)`): The universal 0.5–1px border that separates tonal surfaces.
- **Divider** (`rgba(255,255,255,0.08)`): Even lighter separators between list rows.

### Named Rules
**The One Signal Rule.** Signal Teal covers a small fraction of any screen — live/active/selected/primary only. If teal starts filling large areas or decorating idle surfaces, the signal is broken.

**The Red-Means-Live Rule.** `#FF3B30` is reserved for live status (badge, live accent bar, favorite heart). Never reuse it for generic errors, warnings, or emphasis; errors use the distinct Error Red (`#FF453A`).

**The Committed-Color Rule.** The canvas is a fixed neutral near-black and the accent is one owned teal on every device. Do not enable Material You / dynamic wallpaper tinting.

## Typography

**Display / Body / Label Font:** Inter (bundled locally, weights 400–900; falls back to the system sans).

**Character:** One family doing everything, separated by weight and tracking rather than by mixing typefaces. Content is quiet (regular/medium); metadata is loud in a specific way — tight uppercase tracking — which gives GoPlay its fixtures-board, broadcast-caption voice.

### Hierarchy
- **Display** (w800, 57px, tight `-1px` tracking): Reserved for the largest moments; rarely used in the current app.
- **Headline** (w800, 32px, `-0.5px`): Screen-defining headings and status callouts (e.g. an uppercase "CONNECTION ERROR" at heavy weight with wide tracking).
- **Title** (w700, 22px, `-0.2px`): Screen titles in the app bar and dialog titles.
- **Body** (w400, 14–16px, line-height 1.4): Reading text, descriptions, announcement bodies. Secondary body uses Text Secondary.
- **Label** (w600, 11–14px, `+0.3–0.5px`): Buttons, nav labels, chips, and metadata. The workhorse role.

### Named Rules
**The Tracked-Uppercase Label Rule.** Metadata — league names, LIVE/UPCOMING/quality badges, section headers, kickoff times — is set UPPERCASE with positive letter-spacing. Two accents of this voice exist: hairline section titles (w300, `+1.5px`) that whisper, and heavy status badges (w800–w900, 8–10px, `+0.5–1px`) that shout. Both are uppercase; body text never is.

**The Role-Scale Rule.** Map text to a role (Display / Headline / Title / Body / Label); never hand-pick a one-off size per screen. Sizes follow the Material type scale in `sp`, so they honor the system font setting (clamped 1.0–1.3).

## Layout

Mobile-first single column on a 16px screen gutter (`spacing.gutter`), composed as a scrolling sliver list with a collapsing app bar. Vertical rhythm between major sections is 16–20px; inside cards, padding steps through 4 / 6 / 8 / 12 / 16px.

- **Home** stacks a 108px collapsing app bar (wordmark + search field that docks into the bar as it collapses), a 220px hero carousel, then horizontal rails and vertical lists introduced by section headers.
- **Horizontal rails**: channel avatars are 72px-wide items; compact event cards are a fixed 280px wide; both scroll horizontally with a 16px inset.
- **Grids**: the channel directory is a 2-column grid whose tile height is measured from content so it never overflows at any text scale; Today's Schedule becomes a 3-column event grid at ≥800px width.
- **Responsive / device classes**: portrait phones use a 64px bottom navigation bar; landscape screens and TV/D-pad contexts switch to a 72px left navigation rail (with focus-ring affordances). This is the Material "navigation matched to size" rule in practice.
- **Insets & scaling**: edge-to-edge with transparent system bars; content respects bottom safe-area padding. System text scaling is intentionally clamped to 1.0–1.3 to protect fixed-height cards. Scrolling uses a bouncing (overscroll) physics.

## Elevation & Depth

Flat and tonal, with one reserved lift. Depth is conveyed almost entirely by the five-step tonal surface ladder (`canvas → surface-low → surface → surface-high → surface-highest`) plus hairline borders — not by shadows. Theme elevation is `0` across app bars, cards, buttons, sheets, dialogs, and the nav bar.

The exception is deliberate and narrow: the two elements that genuinely float carry a single soft ambient shadow, and the one primary action carries a teal glow.

### Shadow Vocabulary
- **Ambient Card** (`box-shadow: 0 4px 8px rgba(0,0,0,0.12)`): Match/event cards (both tile and compact variants).
- **Ambient Hero** (`box-shadow: 0 4px 10px rgba(0,0,0,0.12)`): The hero banner carousel cards.
- **Signal Glow** (`box-shadow: 0 2px 6px rgba(0,173,181,0.12)`): The WATCH CTA only — the accent's single permitted glow.

### Named Rules
**The Flat-By-Default Rule.** Surfaces are flat and separated by tone and hairline borders. Do not add drop shadows to ordinary cards, chips, inputs, or list rows.

**The Reserved-Lift Rule.** Only the hero and match cards may lift with Ambient shadows, and only the WATCH CTA may glow. New floating elements must justify themselves against this list, not extend it by default.

## Shapes

A soft-rectangle system on a tight radius ladder, held together by hairlines. Corners scale with element size: 4px badges, 6px live badge, 8px chips/buttons-small/channel cards, 12px event cards & primary buttons & search field, 14px text inputs, 16px large cards & announcements, 20px hero & dialogs, 24px bottom sheets. Circles are reserved for identity (channel logo avatars) and status dots.

Signature geometry:
- **The Accent Bar**: a 4×12px, 2px-radius vertical bar at the left of each event card — Live Red when live, Signal Teal when upcoming. It is the smallest, most repeated brand mark in the app.
- **Channel Avatar Ring**: circular logo wells with a 2px border; the ring turns Signal Teal (at ~31% alpha) when the channel is live.
- **Pill Page Indicator**: hero dots are 6px, expanding to a 16px teal pill for the active page.

### Named Rules
**The Hairline Rule.** Borders are 0.5–1px at `rgba(255,255,255,0.12)`. Never use thick or high-contrast strokes; separation is a whisper, not a box.

**The Rounded-Icon Rule.** Use Material Symbols *rounded* variants (e.g. `search_rounded`, `grid_view_rounded`) to match the soft-rectangle geometry; never mix sharp icon sets.

## Components

### Buttons
- **Shape:** 12px radius (`rounded.lg`); the compact WATCH CTA uses 8px (`rounded.md`).
- **Primary / Filled:** Signal Teal fill, On-Signal (`#00282B`) label, weight 700, padding 24×14px, elevation 0.
- **WATCH CTA:** 32px-tall Signal Teal pill with a play glyph and near-black label (`#17181C`), carrying the Signal Glow shadow. The app's single most emphasized action.
- **Outlined / Text:** hairline-bordered outlined buttons; text buttons use Signal Teal labels. No shadows on any variant.
- **States:** InkRipple splash at low teal alpha; disabled drops to Surface High fill with Muted text.

### Chips
- **Sport filter (Home):** an inverted selection idiom — the *selected* chip is a solid Text-Primary (`#F5F5F7`) fill with near-black label (w700); unselected is Surface fill with white label (w500). 8px radius, 150ms fill transition.
- **Category chips (theme default):** Surface High fill with a hairline border; selected state tints with Signal Teal. Used for channel categories and filters.

### Cards / Containers
- **Channel grid card:** Surface fill, 8px radius, hairline border; a centered circular logo well (54px), a 2-line centered name (11.5px w600), a top-left quality badge (teal, or 4K Blue), and a top-right favorite heart on long-press.
- **Event / match card:** Surface fill, 12px radius, hairline border, **Ambient Card shadow**, and the left Accent Bar. Tile variant is a 96px-tall list row; compact variant is a 280px-wide carousel card. League in tracked uppercase; teams with flags; center shows "VS" (live, teal, w900) or kickoff time / countdown.
- **Announcement tile:** 16px radius; warning uses an amber wash + amber hairline, info uses a white wash + white hairline; leading status icon, title (13px w600) + body (11px).
- **Internal padding:** 8–16px depending on card size.

### Inputs / Fields
- **Style:** Surface High fill, 14px radius, hairline border; leading icon and Muted placeholder.
- **Focus:** border shifts to Signal Teal at 1.5px (no glow). Error uses Error Red border.
- **Search field:** a tappable 44px pill on Home that docks into the collapsing app bar; opens the full search screen.

### Navigation
- **Bottom bar (portrait):** 64px tall, Surface Low ground, top hairline; three destinations (Home / Channels / Upcoming) with rounded icons. Active = Signal Teal icon + label (w700); inactive = Muted (w500). Haptic on tap.
- **Side rail (landscape / TV):** 72px wide, same color logic, with a teal-tinted rounded focus indicator for D-pad focus.

### LIVE Badge (signature)
A pulsing red pill: Live Red fill, 6px radius, a white status dot + "LIVE" (w800, `+1px` tracking). Opacity gently pulses 0.6↔1.0 over 1200ms. The single most recognizable status mark in the product.

### Hero Banner (signature)
A 220px full-bleed carousel card (20px radius, hairline, Ambient Hero shadow): a cover image under a top-and-bottom dark scrim, a league badge (translucent black) and LIVE/UPCOMING badge across the top, and a bottom info bar (near-opaque Surface with a top hairline) carrying team names, a LIVE-NOW / kickoff line, and either the WATCH CTA or a teal-bordered countdown button. Pill page dots sit beneath.

### Section Header (signature)
An uppercase title in a hairline weight (w300, 16px, `+1.5px` tracking) with an optional right-aligned action link (white, w600, 12px). It is the quiet counterpoint to the loud status badges.

## Do's and Don'ts

### Do:
- **Do** reserve Signal Teal (`#00ADB5`) for live, active, selected, and primary only — keep it to a small fraction of any screen (The One Signal Rule).
- **Do** convey depth with the five-step tonal ladder and hairline borders (`rgba(255,255,255,0.12)`); keep surfaces flat.
- **Do** set all metadata — leagues, statuses, quality, section titles, kickoff — in tracked uppercase Inter.
- **Do** limit shadows to the hero and match cards (Ambient) and the WATCH CTA (Signal Glow).
- **Do** map every text style to a role on the Material scale in `sp`, and keep layouts safe within the 1.0–1.3 text-scale clamp.
- **Do** keep touch targets ≥48dp with ≥8dp spacing, and use rounded Material icons.

### Don't:
- **Don't** enable Material You / dynamic wallpaper color; the neutral canvas and single teal are committed on every device.
- **Don't** use Live Red for anything but live status; errors use Error Red (`#FF453A`).
- **Don't** introduce a second decorative accent hue or let teal fill large idle areas.
- **Don't** add drop shadows to ordinary cards, chips, inputs, or rows (The Flat-By-Default Rule).
- **Don't** hand-pick off-scale font sizes or set body copy in uppercase.
- **Don't** ship the (present but unaudited) light theme as the default; dark is the shipped scheme.
