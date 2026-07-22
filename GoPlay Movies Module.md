## Implement GoPlay Movies Module

Implement a complete Movies module for the GoPlay Flutter application while following the existing project architecture and keeping performance as the highest priority.

## Existing Architecture

The project already has:

- Flutter + Material 3

- Riverpod

- GoRouter

- Supabase

- Hive local cache

- Version-based synchronization ( app_settings )

- Background Sync Service

- Repository pattern

- Existing Home, Channels and Upcoming pages

The Movies module must follow the exact same architecture as Channels.

## Goal

Add a new Movies page to the bottom navigation.

Movies are imported automatically from an external M3U source into Supabase every hour (handled separately).

The Flutter app should never parse M3U files directly.

It only communicates with Supabase.

## Navigation

Bottom Navigation:

- Home

- Channels

- Movies

- Upcoming


The Movies page should feel similar to Netflix while remaining lightweight and consistent with GoPlay's

Material 3 design.

## Database

Create a movies model.

Suggested fields:

- id • title • poster • category • language • quality • year • description • stream_url • headers • created_at • updated_at • total_views • daily_views • is_featured

Also extend the version system.

Existing:

- channels_version • events_version

Add:

- movies_version

Movies should participate in the same version-based synchronization flow already used by Channels and Events.


## Local Cache

## Create Hive support for:

- movies

- movie_categories

- movies_version

## The app should:

- Load instantly from Hive

- Check remote version in background

- Download only when versions differ

- Replace cache atomically

- Refresh providers

Reuse the existing SyncService architecture.

## Repository

Create:

MovieRepository

Responsibilities:

• getMovies() • searchMovies() • getMoviesByCategory() • getTrendingMovies() • getPopularMovies() • getRecentlyAdded() • getFeaturedMovie()

No business logic inside widgets.

## Riverpod Providers

Create providers similar to Channels.

Examples:


moviesProvider

featuredMovieProvider

trendingMoviesProvider

popularMoviesProvider

recentMoviesProvider

movieCategoriesProvider

moviesByCategoryProvider(category)

searchMoviesProvider(query)

Keep providers lightweight and derived from cached data whenever possible.

## Movies Home UI

## Design a modern streaming-style home.

## Sections:

## Hero Banner

## Large featured movie.

## Display:

- poster • title • quality • play button

Source:

is_featured == true

## Search

## Sticky search bar.


Instant filtering.

No debounce longer than necessary.

## Category Chips

Horizontal chips.

Examples:

All

Action

Drama

Comedy

Bangla

Hindi

English

Animation

Sci-Fi

Tap updates the grid instantly.

## Sections

Display horizontally scrolling rows.

Trending

Popular

Recently Added

Bangla


Hindi

English

Action

Comedy

Each row should lazy load only visible posters.

## Category Page

## Tapping a category opens:

- AppBar • Search • 2-column poster grid

Support pagination.

Never load thousands of posters at once.

## Movie Card

Simple Material 3 card.

Display:

Poster

Movie Title

Quality Badge

Language Badge

Optional year

Avoid long descriptions.


## Movie Details

Display:

Large poster

Title

Year

Quality

Language

Play button

Description

More Like This

Play should reuse the existing video player.

## Continue Watching

Store locally in Hive.

Remember:

movie id

playback position

last watched

Display on Movies Home.

## Trending

Use:

daily_views


Sort descending.

Top 20.

## Popular

Use:

total_views

Sort descending.

Top 20.

## Recently Added

## Sort by:

created_at DESC

## Featured

Use:

is_featured

Admin controls which movie appears.

## Performance Requirements

## The M3U source contains approximately 24,000 movies.

The UI must remain smooth.

Requirements:

- Never load every movie into memory

- Lazy loading


• Pagination • CachedNetworkImage • Small poster thumbnails • Minimal rebuilds • Keep scrolling at 60fps • Reuse existing providers where possible

## Code Quality

Follow existing project structure.

Keep architecture consistent with Channels.

No duplicated logic.

No large widget classes.

Separate:

Models

Repositories

Providers

Services

Widgets

Pages

## Future Ready

Design the module so future additions require minimal changes.

Examples:

Favorites

Collections

Recommended


Watch History

Movie Ratings

Multiple Sources

Offline Downloads

Do not hardcode homepage sections. Build the homepage so additional sections can be added easily from the backend in the future.

The implementation should feel like a native extension of GoPlay rather than a separate feature.
