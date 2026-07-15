---
name: Fluent Broadcast
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#393939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1b1b1b'
  surface-container: '#20201f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353535'
  on-surface: '#e5e2e1'
  on-surface-variant: '#c0c7d4'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#8a919e'
  outline-variant: '#404752'
  surface-tint: '#a3c9ff'
  primary: '#a3c9ff'
  on-primary: '#00315c'
  primary-container: '#0078d4'
  on-primary-container: '#ffffff'
  inverse-primary: '#0060ab'
  secondary: '#74d1ff'
  on-secondary: '#003548'
  secondary-container: '#159ccb'
  on-secondary-container: '#002e3f'
  tertiary: '#ffb689'
  on-tertiary: '#512300'
  tertiary-container: '#bc5b00'
  on-tertiary-container: '#ffffff'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#d3e3ff'
  primary-fixed-dim: '#a3c9ff'
  on-primary-fixed: '#001c39'
  on-primary-fixed-variant: '#004883'
  secondary-fixed: '#c1e8ff'
  secondary-fixed-dim: '#74d1ff'
  on-secondary-fixed: '#001e2b'
  on-secondary-fixed-variant: '#004d67'
  tertiary-fixed: '#ffdbc8'
  tertiary-fixed-dim: '#ffb689'
  on-tertiary-fixed: '#311300'
  on-tertiary-fixed-variant: '#743500'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353535'
typography:
  display-lg:
    fontFamily: Libre Franklin
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Libre Franklin
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-xs:
    fontFamily: Geist
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
  mono-stats:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  window-margin: 24px
  sidebar-width: 280px
  panel-gap: 2px
  content-padding: 16px
  control-bar-height: 64px
---

## Brand & Style

The design system is engineered for a premium IPTV experience on Windows 11, emphasizing performance, immersion, and professional-grade broadcast monitoring. The brand personality is technical yet sophisticated, mirroring the high-end hardware it runs on. 

The visual style is a strict adherence to **Windows 11 Fluent Design**. It utilizes **Mica** for the primary window material to create a sense of place by subtly incorporating the user's desktop wallpaper through the application surface. **Acrylic** is used for functional sidebars and overlays to provide hierarchical depth and translucency. The aesthetic is clean and utility-focused, avoiding unnecessary decoration in favor of content-first layouts that resemble a professional master control room.

Targeting power users and media enthusiasts, the UI evokes a sense of reliability and cutting-edge technology.

## Colors

The palette is rooted in the deep blacks and charcoals of the Windows dark theme, ensuring that video content remains the focal point without visual distraction.

- **Primary Blue (#0078D4):** Used for active states, primary actions, and progress indicators. It provides a familiar Windows-native feel.
- **Secondary Blue (#60CDFF):** A lighter tint used for hover states and subtle accents against the dark background.
- **Surface Colors:** The main window uses a Mica-effect charcoal. Sidebars use Acrylic textures which are slightly lighter and more translucent to distinguish navigation from content.
- **Semantic Colors:** Critical alerts use a vibrant red, while "Live" indicators utilize a high-visibility pulse of the primary blue or a pure signal white to denote active broadcasting.

## Typography

Typography is optimized for legibility at a distance (10-foot UI considerations) while maintaining the precision of a desktop application. 

**Libre Franklin** is used for headers and titles, providing a sturdy, professional structure that mimics the authoritative feel of news broadcasts. **Inter** handles the bulk of the UI text for its exceptional clarity and neutral tone. **Geist** is introduced for labels and technical "Stats for Nerds" overlays, leveraging its monospaced-adjacent qualities to present bitrate, resolution, and frame-rate data with mathematical precision.

Text colors are tiered: High-contrast white (#FFFFFF) for primary headers, Light Gray (#E5E5E5) for body text, and Muted Gray (#A1A1A1) for secondary metadata.

## Layout & Spacing

This design system uses a **Fixed Grid** desktop-first model optimized for 16:9 and 21:9 aspect ratios. 

- **The Monitoring Layout:** The main viewport is dominated by the video player. A right-hand sidebar (Acrylic) contains the channel list and categories, allowing for channel surfing without exiting the live stream.
- **Minimal Separators:** Instead of heavy borders, panels are separated by 2px "hairline" gaps or subtle tonal shifts in the background material.
- **Sidebar:** Fixed at 280px. It can be collapsed to an "Icon-only" rail (48px) to maximize video real estate.
- **Control Bar:** A floating or docked persistent bar at the bottom containing playback controls, volume, and stream settings, using a height of 64px for easy mouse targeting.

## Elevation & Depth

Depth is established through the interaction of materials rather than traditional drop shadows.

- **Mica (Base):** The foundational layer of the application window.
- **Acrylic (Overlays):** Used for sidebars and menus. It creates a "layer 1" elevation that feels physically closer to the user.
- **Hover States:** Instead of elevation, hover states use a "reveal" highlight—a subtle white or light gray 5-10% opacity overlay that follows the cursor or fills the container, consistent with Windows 11 dashboard patterns.
- **Outlines:** Focused elements (like the selected channel) use a 2px solid stroke of the Primary Blue (#0078D4) to indicate the active input target.

## Shapes

The shape language follows the modern Windows standard. All primary window corners and major container panels (like the video player viewport) use a **12px (rounded-xl)** radius. 

Smaller internal components like buttons, input fields, and channel thumbnails use an **8px (rounded-lg)** radius. This nesting of radii (smaller inside larger) creates a harmonious, "built-in" look that feels native to the OS.

## Components

### Buttons
- **Action Buttons:** Subtle semi-transparent gray backgrounds with white text. On hover, they brighten.
- **Primary Action:** Solid Blue (#0078D4) with white text, used sparingly for "Connect" or "Upgrade" actions.
- **Icon Buttons:** No visible container until hover; then a soft gray rounded-square appears.

### Channel List (Cards/List Items)
- **Monitoring Style:** High-density list items. Each row contains a small 16:9 thumbnail, channel name, and a "Live" indicator.
- **Active State:** The entire row takes a subtle blue tint or a left-aligned 4px blue accent pill.

### Input Fields
- **Search:** Located at the top of the sidebar. Minimalist design with a bottom-border focus state and a Windows-style magnifying glass icon.

### Video Player Controls
- **Glass-morphic Bar:** The control bar uses a high-blur Acrylic background. Icons are Windows 11 "Fluent" style SVG icons (thin lines, slightly rounded ends).
- **Progress Bar:** A thin 4px line that expands to 8px on hover, using the Primary Blue for the elapsed time.

### Chips & Tags
- **Category Chips:** Small, pill-shaped tags used for genres (e.g., "Sports", "4K", "HEVC"). They use a dark gray background with Geist-font labels.