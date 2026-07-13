# Build Plan — Deathmatch Arena

Work top to bottom. Don't start a phase until the previous one's checklist is
done. **Phases 1–3 = the prototype.** Phases 4–6 are explicitly post-prototype.

Before Phase 1: resolve the rendering/physics decision in ARCHITECTURE.md
(Option A/B/C) and record the choice in PROGRESS.md's Decision Log.

---

## Phase 0 — Repo setup
- [ ] `npx create-expo-app` with TypeScript template
- [ ] Install: `expo-gl`, `three`, `@react-three/fiber`, `@react-three/drei`,
      `cannon-es`, `react-native-reanimated`, `zustand` (adjust if a different
      rendering option was chosen)
- [ ] Set up Expo Router with placeholder screens: menu, character-select,
      fight, results
- [ ] Confirm the app builds and runs on a real iPhone (or simulator) with a
      blank 3D scene rendering via react-three-fiber before writing any game
      logic

## Phase 1 — Foundation
- [ ] Fixed-timestep game loop in `src/game/engine`
- [ ] cannon-es physics world initialized, single flat ground plane, one
      capsule body falling under gravity as a smoke test
- [ ] Reusable UI components: buttons, panel, meter bar
- [ ] Main menu screen wired to navigation (no functionality behind
      Multiplayer/Shop/Leaderboard yet — placeholder screens are fine)
- [ ] Skip Supabase entirely in this phase

## Phase 2 — Combat core
- [ ] Virtual joystick (movement) + 4 action buttons (punch/kick/grab/special)
      wired to input state
- [ ] One fighter rig with basic ragdoll joints (cannon-es constraints)
      responds to movement input
- [ ] Hitboxes/hurtboxes for punch and kick; damage calc as a pure function
      in `src/game/combat`
- [ ] Health + Stamina meters functional and wired to combat outcomes
- [ ] Knockback + stumble on hit feels distinct from a full ragdoll knockout
- [ ] Two fighters can fight each other locally (no AI yet — hot-seat or
      debug-controlled second fighter is fine for testing)

## Phase 3 — First playable slice (prototype target)
- [ ] Build 2 characters from GAME_DESIGN.md roster (recommend: The Action
      Hero, The Wrestler) with distinct stats affecting combat math
- [ ] Build 1 arena (recommend: Wrestling Ring) with one working hazard
- [ ] Hype meter fills from landed hits/hazard chaos
- [ ] One finisher works end-to-end: Hype threshold reached → input trigger →
      camera zoom → VFX/hazard sequence → forced match end → results screen
- [ ] Basic AI opponent (single difficulty tier is enough for the prototype)
      using the same combat resolution functions as the player
- [ ] Sound: at least placeholder impact SFX and one music bed
- [ ] Full loop playable start to finish: menu → character select → fight →
      winner screen → play again, at a stable framerate on a real device

**Prototype is done when Phase 3's checklist is fully checked.** Confirm this
with a real playtest before moving to Phase 4.

---

## Phase 4 — Content expansion (post-prototype)
- [ ] Remaining arenas (up to 6 total) with their hazards
- [ ] Remaining characters (up to 10 total)
- [ ] All 4 AI difficulty tiers (Easy/Medium/Hard/Nightmare)
- [ ] Additional finishers
- [ ] Full sound pass: crowd reactions, announcer barks, per-arena music

## Phase 5 — Progression (post-prototype)
- [ ] XP, levels, coins, cosmetic unlocks
- [ ] Daily challenges
- [ ] Achievements
- [ ] Local leaderboard (no backend yet)

## Phase 6 — Online (post-prototype)
- [ ] Supabase project + schema from ARCHITECTURE.md
- [ ] Auth
- [ ] Matchmaking (Realtime)
- [ ] Private friend lobbies
- [ ] Seasonal rankings, global/friends/country leaderboards

## Phase 7 — Polish & ship prep (post-prototype)
- [ ] Screen shake, particle polish, camera zoom refinement
- [ ] Menu polish to match art direction (CRT scanlines, chrome, arcade fonts)
- [ ] Performance pass against targets (60fps, <500MB, <5s load) across
      supported device range (iPhone SE → newest)
- [ ] App Store assets, screenshots, description
- [ ] TestFlight build via EAS

---

## Explicitly deferred (stretch goals, not scheduled)
- Create-a-Fighter (selfie → AI-generated character)
- Replay system + auto vertical-video export for social sharing
- Weekly themed events
- Tournament mode (8-player bracket)
- Controller support
- Android port
