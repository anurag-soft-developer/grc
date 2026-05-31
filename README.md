# GRC Flutter app

Mobile client for [grc-services](../grc-services). Uses **GetX** (routing, guards, form controllers) and **flutter_query** (API loading/error via `useQuery` / `useMutation`).

## Setup

1. Copy environment file:
   ```bash
   cp .env.example .env
   ```
   Set `BASE_API_URL` (Android emulator: `http://10.0.2.2:3000`), `GOOGLE_CLIENT_ID`, and `GOOGLE_PLACES_API_KEY` (Places API + Place Details enabled).

2. Install dependencies and generate mappers:
   ```bash
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Run:
   ```bash
   flutter run
   ```

Requires Flutter **>= 3.32** (flutter_query).

## Structure

- `lib/core/` — API, auth, routes, query keys
- `lib/profile/`, `lib/settings/` — account flows
- `lib/features/` — Home / Events / Registrations placeholders

## API

Bearer auth against grc-services: `/auth/*`, `/users/profile`, `/storage/upload-url` (avatar uploads).
