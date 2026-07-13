# Progress — Deathmatch Arena

Update this file at the end of every session. Keep entries short — this is a
status board, not a diary.

## Current phase
**Godot 4 rebuild — full playable game loop done & verified** (see the Godot
section below). Old Expo/RN build is retired (kept in git history as a spec).

## Godot build status (2026-07-13)
Engine migrated to Godot 4.7 (see ENGINE_EVALUATION.md). The `godot/` project
is a complete, verified-on-desktop playable game:
- **Full loop:** Main Menu → Character Select (10 fighters) → VS screen →
  Fight → Results, all wired and screenshot-verified.
- **Fight (G1):** 2.5D ring (floor/posts/ropes), two characterful fighters
  (torso + oversized head + limbs, shadows), joystick + P/K/G/S touch controls
  + keyboard, combat via `GameData.resolve_move`, single-tier-per-setting AI,
  live Health/Stamina/Hype HUD, timed arena hazard, **two-stage KO** (weaken →
  "FINISH!" → Hype finisher with camera punch-in + comedic flop), plain K.O.
  otherwise.
- **Presentation (G2):** MTV-chrome UI kit (`UI.gd`), portrait select, VS beat,
  Settings (difficulty → AI reaction), Leaderboard (live profile).
- **Progression (G5-equiv):** `PlayerProfile` autoload persists
  XP/level/coins/wins/streak/achievements/dailies to `user://profile.json`.
- **Verify loop:** `godot/verify.sh` + `Shot` autoload (`--goto`/`--debug`/
  `--screenshot`) render any screen headlessly. Uses the GL-compatibility
  renderer (this Intel Mac's MoltenVK is broken); iOS uses native Metal.

Also done: procedural SFX + looping crowd (`Audio` autoload), crowd backdrop,
random arena per match (all 6), global CRT scanline/vignette overlay (`CRT`),
UI click sound.

Remaining for a fuller "done": real low-poly character models (placeholder
box+head fighters today), announcer VO + music bed, career/shop screens
(shop is a placeholder), then **G7 ship** — iOS export needs Godot's iOS
export templates + **your Apple Developer account** for signing/TestFlight;
Supabase online needs **your project keys** (integrate via Godot
HTTPRequest/WebSocket). These are the only genuinely blocked items.

## (Historical — Expo/RN build, retired)

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

## Verified on simulator (2026-07-13)
Ran `npx expo run:ios` end-to-end and confirmed the app boots on iPhone 17 Pro
(iOS simulator) with the main menu rendering correctly and Expo Router
navigation working. Hit and fixed several environment issues along the way,
worth knowing about for future sessions:

- **CocoaPods + non-UTF-8 shell locale**: first `pod install` crashed with a
  Ruby `Encoding::CompatibilityError`. Fix: run with
  `LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8`.
- **This repo lives inside an iCloud-synced Documents folder.** iCloud's file
  provider stamps newly-created build files with `com.apple.FinderInfo` /
  `com.apple.fileprovider.fpfs#P` metadata that `codesign` rejects
  ("resource fork, Finder information, or similar detritus not allowed") when
  signing the ExpoModulesJSI xcframework, and also causes intermittent
  "Build input file cannot be found" errors for React codegen output because
  freshly-written files aren't reliably visible to Xcode's build system.
  **Fix applied**: `node_modules` and `ios/build` are relocated to
  `~/.local-build-cache/tehdeathmatchgame/` and symlinked back into the repo
  (`ios/` itself must stay a real directory — Podfile scripts resolve
  `ios/..` paths and break if `ios` itself is a symlink). If this project is
  ever moved to a non-iCloud-synced path, these symlinks can be undone by
  moving the real directories back and deleting the cache folder.
- **`babel-preset-expo` got silently pruned** from `node_modules` during one
  of the `npm install --legacy-peer-deps` passes (it's an optional peer dep
  of `expo`, not a direct dependency) — Metro failed with `MODULE_NOT_FOUND`.
  Fixed by adding it explicitly: `npm install --save-dev babel-preset-expo`.
  If Metro ever throws this again, that's the fix.
- **First clean codegen build is flaky**: Xcode's build system sometimes
  looks for React codegen `.mm`/`.cpp` output before the "Generate Specs"
  script phase has produced it ("Build input file cannot be found"). A plain
  retry usually clears it; if not, pre-run
  `node node_modules/react-native/scripts/generate-codegen-artifacts.js -p . -t ios -o ios/build`
  before building.

Not yet verified: actually playing a match (this environment has no touch-
input simulation available, only screenshots) — the user should tap through
PLAY → character select → fight themselves on the already-booted simulator to
confirm combat feels right and holds framerate.

## Next up
See **`docs/NEXT_STEPS.md`** — the authoritative go-forward plan, informed by
the *MTV's Celebrity Deathmatch* reference. Immediate blocker: the fight
screen renders pure black (expo-gl / r3f Canvas not painting) — Phase 0.1.

Known bugs confirmed on-device (2026-07-13):
- Fight `<Canvas>` renders nothing — not even the arena background color.
- `MeterBar` fill never shows (Reanimated can't animate width to a `%` string).
- Character-select cards stretch to full screen height.

## Decision log
| Date | Decision | Why |
|---|---|---|
| 2026-07-13 | Rendering/physics stack: Option B (react-three-fiber + expo-gl + cannon-es) | User confirmed going with the documented recommendation; dev machine has Xcode 26.3 + simulator ready, so the slower native iteration loop is acceptable. |
| 2026-07-13 | **SUPERSEDED — migrate engine to Godot 4** (see `docs/ENGINE_EVALUATION.md`) | expo-gl does not render on the iOS Simulator (pure black) and the native loop is slow/fragile; Godot 4.4+ has a Metal renderer (renders in sim + on desktop), built-in Jolt physics/ragdoll, and instant in-editor iteration. Design + roadmap preserved; only the stack changes. Godot 4.7 installed. |
