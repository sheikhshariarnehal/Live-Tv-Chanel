/// App-wide constants and configuration
class AppConstants {
  AppConstants._();

  // Supabase
  static const String supabaseUrl = 'https://hqmhuvsjlykrdusfkmeg.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhxbWh1dnNqbHlrcmR1c2ZrbWVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI4MjI3OTEsImV4cCI6MjA5ODM5ODc5MX0.sfNEW7QG0idyVVRHlDtYjITDfIbsFQQm2u9a3ffoNoA';

  // Hive Box Names
  static const String channelsBox = 'channels_cache';
  static const String eventsBox = 'events_cache';
  static const String categoriesBox = 'categories_cache';
  static const String settingsBox = 'settings';
  static const String watchHistoryBox = 'watch_history_local';
  static const String favoritesBox = 'favorites_local';

  // App Info
  static const String appName = 'GoPlay';
  static const String appVersion = '1.0.0';
}
