# SafeOps AI — Worker Mobile App

> Flutter app for factory workers — real-time PPE violation history, emergency evacuation alarms, and privacy-preserving compliance tracking.

Built at **HackNiche 2025** · Companion app to [SafeGuard AI Web Platform](https://github.com/kabir-999/hackniche)

---

## Overview

SafeOps AI Worker App is the mobile companion to the SafeOps industrial PPE monitoring system. It puts two critical capabilities directly in each worker's hands:

1. **Personal PPE violation history** — a running log of every time the worker was flagged for missing PPE equipment during their shift, so they can track and improve their own compliance.
2. **Emergency evacuation alarm** — when a supervisor triggers a fire or medical emergency alert from the web dashboard, every worker's phone instantly blares an alarm with full-screen evacuation instructions.

The app is built with **privacy-first principles**, no location tracking, no surveillance, no identity exposure to management.

---

## Features

### Authentication
- Email/password sign-up and login via Supabase Auth
- Google Sign-In support
- Persistent session — workers stay logged in across app restarts

### Real-Time Emergency Alarm
- Listens to the Supabase `alarms` table every 3 seconds via polling
- When `is_fire = true` — triggers a **CRITICAL** full-screen red alert with audio alarm and device vibration
- When `is_fall = true` — triggers a **HIGH** alert for medical emergency
- Alarm includes evacuation instructions and zone location
- Workers must actively acknowledge the alarm to dismiss it
- Uses `audioplayers` for alarm sound and `vibration` package for haptic feedback

### PPE Violation History
- Each worker sees their own personal log of PPE violations detected by the camera system
- Displays: timestamp, zone, and which PPE item was missing (helmet, vest, gloves, etc.)
- Updated automatically as new violations are logged by the detection model
- **Only the individual worker sees their own history** — managers have no access to per-worker identity data

### Home Dashboard
- Quick summary of today's compliance status
- Count of violations in current shift
- Current alarm status indicator

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Supabase Auth (Email + Google) |
| Database | Supabase (PostgreSQL) |
| Realtime | Supabase polling (3s interval) |
| Alarm Audio | `audioplayers` |
| Haptics | `vibration` |
| Platforms | Android, iOS |

---

## Project Structure

```
Hackniche_app/
├── lib/
│   ├── main.dart               # App entry, Supabase init
│   ├── screens/
│   │   ├── splash_screen.dart  # Splash + auth routing
│   │   ├── login_screen.dart   # Login with email/Google
│   │   ├── signup_screen.dart  # New worker registration
│   │   ├── home_screen.dart    # Worker dashboard
│   │   └── alarm_screen.dart   # Full-screen emergency alert
│   ├── services/
│   │   ├── alarm_service.dart  # Supabase alarm polling
│   │   └── auth_service.dart   # Auth helpers
│   └── widgets/                # Reusable UI components
├── assets/
│   └── alarm.mp3               # Emergency alarm sound
├── android/                    # Android native config
├── ios/                        # iOS native config
├── pubspec.yaml
└── README.md
```

---

## Setup & Installation

### Prerequisites
- Flutter SDK 3.x+
- Dart 3.x+
- A Supabase project (shared with the web platform)
- Android Studio or Xcode for device/emulator

### 1. Clone the repo
```bash
git clone https://github.com/Aagnya-Mistry/Hackniche_app.git
cd Hackniche_app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure Supabase credentials

Run the app with your Supabase project values:
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or create a `lib/config.dart` file:
```dart
const supabaseUrl = 'https://your-project.supabase.co';
const supabaseAnonKey = 'your-anon-key';
```

### 4. Supabase Requirements

#### Auth Setup
In your Supabase dashboard, enable:
- **Email/Password** authentication
- **Google OAuth** (optional)

For Google sign-in on Android, add this redirect URL in Supabase Auth settings:
```
io.supabase.flutter://login-callback/
```

#### Database Tables

The app requires the following tables (set up via the web platform or manually):

```sql
-- Emergency alarm state (one shared row, updated by web dashboard)
create table alarms (
  id uuid default gen_random_uuid() primary key,
  is_fire boolean default false,
  is_fall boolean default false,
  location text,
  triggered_at timestamptz default now()
);

insert into alarms (is_fire, is_fall, location) values (false, false, '');

-- PPE violation history per worker
create table violations (
  id uuid default gen_random_uuid() primary key,
  worker_id uuid references auth.users(id),
  zone text,
  violation_type text,
  timestamp timestamptz default now()
);
```

---

## How the Alarm Works

```
Supervisor triggers emergency on web dashboard
            ↓
Supabase alarms table updated:
  { is_fire: true, location: "Zone B" }
            ↓
Worker app polls every 3 seconds
            ↓
is_fire = true detected
            ↓
Audio alarm plays + device vibrates
Full-screen red alert shown
Worker must press ACKNOWLEDGE to dismiss
```

The same flow applies for `is_fall = true` (medical emergency).

---

## Privacy Design

- Workers only see **their own** violation history — scoped by `worker_id` from Supabase Auth
- No manager or supervisor can access individual worker violation records through this app
- No GPS or location data is collected from the worker's device
- The alarm system broadcasts by **updating a shared DB row** — no individual targeting

---

## Future Scope

**Personalized PPE Violation Alerts via QR + Asymmetric Encryption**
Workers will be issued a QR code on their uniform encoding a public key. When the YOLO model detects a violation, the system encrypts the worker's identifier with their public key and pushes it to all devices. Only the matching worker's app — holding the private key — can decrypt and display the alert. Zero identity exposure at any layer.

**Biometric App Lock**
Add fingerprint/Face ID lock to the app so violation history remains private even if the phone is borrowed.

**Offline Alarm Support**
Cache the last known alarm state locally so the app can trigger evacuation alerts even during brief network outages using local notifications.

**Multi-Language Support**
Factory workers across India speak diverse languages — add support for Hindi, Marathi, Gujarati, and Tamil for alarm messages and PPE instructions.

---

## Running Tests & Analysis

```bash
flutter analyze
flutter test
```

---

## Team

Built at HackNiche 2025

- **Aagnya Mistry** — Flutter App · [@Aagnya-Mistry](https://github.com/Aagnya-Mistry)
- **Kabir** — Web Platform & CV Model · [@kabir-999](https://github.com/kabir-999)
- Chhavi Rathod - Frontend, Supabase Setup . [@chhavirathod](https://github.com/chhavirathod)
- Aayush Chaudhari - CV Model, Dashboard . [@aayushhh-operator](https://github.com/aayushhh-operator)

---

## Related Repositories

- Web Dashboard + CV Model: [github.com/kabir-999/hackniche](https://github.com/kabir-999/hackniche)
