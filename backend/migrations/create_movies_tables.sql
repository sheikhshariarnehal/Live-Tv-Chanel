-- ========================================================
-- GoPlay Movies Module Supabase Database Migration
-- ========================================================

-- 1. Create Categories Table for Movies
CREATE TABLE IF NOT EXISTS public.movie_categories (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    sort_order INT DEFAULT 0,
    icon TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Movies Table
CREATE TABLE IF NOT EXISTS public.movies (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    poster TEXT,
    category_id TEXT REFERENCES public.movie_categories(id) ON DELETE SET NULL,
    language TEXT,
    quality TEXT,
    year INT,
    description TEXT,
    stream_url TEXT NOT NULL,
    headers JSONB DEFAULT '{}'::jsonb,
    total_views INT DEFAULT 0,
    daily_views INT DEFAULT 0,
    is_featured BOOLEAN DEFAULT FALSE,
    is_trending BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for high-performance querying and pagination
CREATE INDEX IF NOT EXISTS idx_movies_category ON public.movies(category_id);
CREATE INDEX IF NOT EXISTS idx_movies_is_featured ON public.movies(is_featured) WHERE is_featured = TRUE;
CREATE INDEX IF NOT EXISTS idx_movies_is_trending ON public.movies(is_trending) WHERE is_trending = TRUE;
CREATE INDEX IF NOT EXISTS idx_movies_daily_views ON public.movies(daily_views DESC);
CREATE INDEX IF NOT EXISTS idx_movies_created_at ON public.movies(created_at DESC);

-- 3. Extend app_settings table for version-based synchronization
ALTER TABLE public.app_settings
ADD COLUMN IF NOT EXISTS movies_version INT DEFAULT 1;

-- Ensure initial row in app_settings exists
INSERT INTO public.app_settings (id, channels_version, events_version, movies_version)
VALUES (1, 1, 1, 1)
ON CONFLICT (id) DO UPDATE SET movies_version = COALESCE(public.app_settings.movies_version, 1);
