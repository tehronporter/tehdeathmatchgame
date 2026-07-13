# Progress — Deathmatch Arena

Update this file at the end of every session. Keep entries short — this is a
status board, not a diary.

## Current phase
Phase 5 complete (client-side). Phases 6-7 blocked on external credentials
(see below) — everything code-only within them is done.

## Completed
- Phase 0: Expo Router scaffold, all core deps (r3f, cannon-es, reanimated,
  zustand, expo-router), menu/match screen structure, expo-doctor clean.
- Phase 1: fixed-timestep `GameLoop`, cannon-es world + physics smoke test,
  reusable UI kit (ArcadeButton, Panel, MeterBar w/ Reanimated), main menu
  wired to navigation.
- Phase 2: virtual joystick + 4 action buttons, two-body fighter rig
  (torso + head via ConeTwistConstraint) as the ragdoll stand-in, pure
  `resolveMove` combat math, Health/Stamina/Hype meters wired live, local
  two-fighter combat loop.
- Phase 3: full 10-character roster + 6 arenas w/ hazards + 7 finishers (data
  complete; prototype-critical pair is Action Hero vs Wrestler in Wrestling
  Ring per BUILD_PLAN), Hype-triggered finisher end-to-end (trigger → camera
  zoom stub → banner → forced match end → results), BasicAI opponent sharing
  `resolveMove` with the player, placeholder-primitive menu→select→fight→
  results loop fully wired.
- Phase 4: all 10 characters/6 arenas/7 finishers built as data, 4 AI
  difficulty tiers (easy/medium/hard/nightmare) in `src/game/ai/difficulty.ts`.
  No sound assets yet (no placeholder SFX files exist in the repo).
- Phase 5: local-only progression via `usePlayerStore` (AsyncStorage-backed
  zustand) — XP/level/coins, win streaks, achievements, daily challenges,
  local leaderboard screen. No backend, as required.
- Phase 7 (partial): screen-shake-on-hit implemented (`src/render/effects`).

## Blocked — needs the user, not more code
- **Phase 6 (Supabase online multiplayer/backend).** Schema
  (`supabase/migrations/0001_init.sql`) and client (`src/supabase/client.ts`,
  reads `EXPO_PUBLIC_SUPABASE_URL`/`EXPO_PUBLIC_SUPABASE_ANON_KEY` from `.env`)
  are scaffolded but inert — nothing imports the client yet. Needs an actual
  Supabase project; creating accounts on the user's behalf is out of scope.
- **Phase 7 (TestFlight ship).** EAS build/submit needs `eas login` against
  the user's own Apple Developer Program account. Not something to do
  autonomously. App Store screenshots/description also need real device
  captures once the game is playtested.
- **Real 3D low-poly character/arena assets.** Every character and arena
  currently renders as primitive boxes/spheres/planes colored per-character.
  This is fine for playtesting the combat feel, but is not what PRD.md means
  by "PS1 low-poly." No art pipeline exists yet — needs either a commissioned
  artist, a marketplace low-poly asset pack, or an AI mesh-gen pipeline.

## Next up
- Playtest the local prototype on-device (first `pod install` hit a
  CocoaPods/locale bug, resolved by rerunning with `LANG=en_US.UTF-8`).
- Once playtested: source real character/arena assets, then decide when to
  spend the user's own credentials on Supabase + Apple Developer setup.

## Decision log
| Date | Decision | Why |
|---|---|---|
| 2026-07-13 | Rendering/physics stack: Option B (react-three-fiber + expo-gl + cannon-es) | User confirmed going with the documented recommendation; dev machine has Xcode 26.3 + simulator ready, so the slower native iteration loop is acceptable. |
