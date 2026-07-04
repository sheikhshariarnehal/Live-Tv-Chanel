# Implement Version-Based Channel Sync with Local Cache

Implement a production-ready version-based synchronization system for the Flutter IPTV application.

## Goal

The app should **never download the full channel list unless it has actually changed**.

Instead:

1. Store all channels locally.
2. Store the current channel version locally.
3. On app startup, request only the latest version number from Supabase.
4. If the version is unchanged, immediately use the local cache.
5. If the version has changed, download the latest channels, replace the local cache, and update the stored version.

This system must minimize Supabase reads and provide fast startup.

---

# Architecture

```
Flutter App
      │
      ├── Isar (or Hive)
      │       ├── channels
      │       └── local_version
      │
      └── Supabase
              ├── app_settings
              │       channel_version
              │
              └── channels
```

---

# Database

Create an `app_settings` table.

Columns:

* id (always 1)
* channel_version (integer)
* updated_at (timestamp)

Example:

```
id = 1
channel_version = 1
```

Every time the admin edits channels:

```
UPDATE app_settings
SET
channel_version = channel_version + 1,
updated_at = NOW()
WHERE id = 1;
```

Never modify the version anywhere else.

---

# Local Storage

Use Isar (preferred) or Hive.

Store:

```
channels
```

and

```
local_channel_version
```

Example:

```
local_channel_version = 5
```

---

# Startup Flow

When the application launches:

```
Load channels from local database

↓

Display immediately

↓

Request ONLY:

SELECT channel_version
FROM app_settings
WHERE id = 1

↓

Compare versions

↓

Same?

YES
    Stop.

NO
    Download latest channels
    Replace local database
    Save new version
```

The UI should never wait for the version check before displaying cached data.

---

# Repository Layer

Create a repository:

```
ChannelRepository
```

Methods:

```
Future<List<Channel>> loadLocalChannels()

Future<int> fetchRemoteVersion()

Future<List<Channel>> downloadChannels()

Future<void> replaceLocalChannels()

Future<void> saveLocalVersion()

Future<int> getLocalVersion()

Future<bool> needsSync()
```

---

# Sync Service

Create:

```
ChannelSyncService
```

Method:

```
Future<void> syncIfNeeded()
```

Pseudo code:

```
localVersion = getLocalVersion()

remoteVersion = fetchRemoteVersion()

if(localVersion == remoteVersion){

    return;

}

channels = downloadChannels()

replaceLocalChannels(channels)

saveLocalVersion(remoteVersion)
```

---

# UI Behaviour

When opening the app:

```
Show cached channels instantly.

Do NOT show loading
if cache already exists.

Run sync in background.

If new data arrives,
refresh provider/BLoC/Riverpod state automatically.
```

Users should not notice the synchronization.

---

# First Install

If there is no cache:

```
Download channels

Save locally

Save version

Display channels
```

---

# Error Handling

If Supabase is unavailable:

```
Use local cache.

Do not clear data.

Retry next launch.
```

If downloading channels fails:

```
Keep existing cache.

Do not overwrite.

Log the error.
```

---

# Performance Requirements

Never download channels if versions match.

Only one lightweight query should be executed on startup:

```
SELECT channel_version
FROM app_settings
WHERE id = 1;
```

Avoid loading unnecessary columns or rows.

---

# Code Quality

* Follow clean architecture.
* Separate repository, service, and UI layers.
* Use immutable models.
* Add comments explaining the synchronization flow.
* Write reusable, testable code.
* Ensure synchronization cannot create duplicate records.

---

# Expected Result

Normal app startup:

```
Launch app

↓

Load local cache instantly

↓

Check version (one small query)

↓

No changes

↓

Done
```

After an admin updates channels:

```
Launch app

↓

Load cached channels

↓

Version changed

↓

Download latest channels

↓

Replace cache

↓

Update UI

↓

Save new version
```

The implementation should be optimized for future scalability to tens of thousands of users while minimizing Supabase database reads.
