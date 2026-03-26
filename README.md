# SafeOps AI

SafeOps AI is a Flutter mobile app for factory workers. It provides:

- splash, login, signup, and home screens
- Supabase authentication with email/password and Google sign-in
- a worker dashboard that shows PPE history records
- a real-time accident alarm triggered from the Supabase `alarms` table

## Tech Stack

- Flutter
- Supabase Auth
- Supabase database polling
- `audioplayers` for alarm audio
- `vibration` for device vibration

## Run the App

Use your Supabase project values when running the app:

```powershell
flutter run `
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co `
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## Supabase Requirements

### Auth

Enable the auth methods you want to use:

- Email and Password
- Google

For Google sign-in on Android, the redirect URL must include:

```text
io.supabase.flutter://login-callback/
```

### Alarm Table

The app polls the Supabase `alarms` table every 3 seconds.

Expected columns:

- `id`
- `location`
- `is_fire`
- `is_fall`

Alarm behavior:

- `is_fire = true` triggers a critical alert
- `is_fall = true` triggers a high alert
- either one starts the alarm, vibration, and full-screen alert dialog

## Verification

Run the checks with:

```powershell
flutter analyze
flutter test
```
