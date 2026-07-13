# Build Plan — Deathmatch Arena

Work top to bottom. Don't start a phase until the previous one's checklist is
done. **Phases 1–3 = the prototype.** Phases 4–6 are explicitly post-prototype.

Before Phase 1: resolve the rendering/physics decision in ARCHITECTURE.md
(Option A/B/C) and record the choice in PROGRESS.md's Decision Log.

---

## Phase 0 — Repo setup
- [x] `npx create-expo-app` with TypeScript template
- [x] Install: `expo-gl`, `three`, `@react-three/fiber`, `@react-three/drei`,
      `cannon-es`, `react-native-reanimated`, `zustand` (adjust if a different
      rendering option was chosen)
- [x] Set up Expo Router with placeholder screens: menu, character-select,
      fight, results
- [x] Confirm the app builds and runs on a real iPhone (or simulator) with a
      blank 3D scene rendering via react-three-fiber before writing any game
      logic

## Phase 1 — Foundation
- [x] Fixed-timestep game loop in `src/game/engine`
- [x] cannon-es physics world initialized, single flat ground plane, one
      capsule body falling under gravity as a smoke test (`src/render/scenes`
      history — superseded by FightScene once Phase 2 landed)
- [x] Reusable UI components: buttons, panel, meter bar
- [x] Main menu screen wired to navigation (no functionality behind
      Multiplayer/Shop/Leaderboard yet — placeholder screens are fine)
- [x] Skip Supabase entirely in this phase

## Phase 2 — Combat core
- [x] Virtual joystick (movement) + 4 action buttons (punch/kick/grab/special)
      wired to input state
- [x] One fighter rig with basic ragdoll joints (cannon-es constraints)
      responds to movement input — torso + head via `ConeTwistConstraint`
      (cannon-es has no native capsule shape; this is the simplified stand-in)
- [x] Hitboxes/hurtboxes for punch and kick; damage calc as a pure function
      in `src/game/combat`
- [x] Health + Stamina meters functional and wired to combat outcomes
- [x] Knockback + stumble on hit feels distinct from a full ragdoll knockout
- [x] Two fighters can fight each other locally (no AI yet — hot-seat or
      debug-controlled second fighter is fine for testing)

## Phase 3 — First playable slice (prototype target)
- [x] Build 2 characters from GAME_DESIGN.md roster (recommend: The Action
      Hero, The Wrestler) with distinct stats affecting combat math
- [x] Build 1 arena (recommend: Wrestling Ring) with one working hazard
- [x] Hype meter fills from landed hits/hazard chaos
- [x] One finisher works end-to-end: Hype threshold reached → input trigger →
      camera zoom → VFX/hazard sequence → forced match end → results screen
      (camera zoom/VFX are a text banner + screen shake stand-in, not real
      finisher animations — no 3D assets exist yet, see PROGRESS.md)
- [x] Basic AI opponent (single difficulty tier is enough for the prototype)
      using the same combat resolution functions as the player
- [ ] Sound: at least placeholder impact SFX and one music bed — **not done,
      no audio asset files exist in the repo yet**
- [x] Full loop playable start to finish: menu → character select → fight →
      winner screen → play again (framerate not yet confirmed on a real
      device — see PROGRESS.md playtest note)

**Prototype is done when Phase 3's checklist is fully checked.** Confirm this
with a real playtest before moving to Phase 4.

---

## Phase 4 — Content expansion (post-prototype)
- [x] Remaining arenas (up to 6 total) with their hazards
- [x] Remaining characters (up to 10 total)
- [x] All 4 AI difficulty tiers (Easy/Medium/Hard/Nightmare)
- [x] Additional finishers (data only — see Phase 3 VFX note)
- [ ] Full sound pass: crowd reactions, announcer barks, per-arena music —
      **not done, no audio pipeline set up yet**

## Phase 5 — Progression (post-prototype)
- [x] XP, levels, coins, cosmetic unlocks (cosmetic unlocks: coins accrue but
      nothing to spend them on yet — Shop screen is still a placeholder)
- [x] Daily challenges
- [x] Achievements
- [x] Local leaderboard (no backend yet)

## Phase 6 — Online (post-prototype)
- [ ] Supabase project + schema from ARCHITECTURE.md — **schema file and
      client scaffolded (`supabase/migrations/0001_init.sql`,
      `src/supabase/client.ts`), but no live Supabase project exists.
      Creating that account/project is the user's to do, not something to
      automate.**
- [ ] Auth — blocked on the above
- [ ] Matchmaking (Realtime) — blocked on the above
- [ ] Private friend lobbies — blocked on the above
- [ ] Seasonal rankings, global/friends/country leaderboards — blocked on the
      above

## Phase 7 — Polish & ship prep (post-prototype)
- [x] Screen shake (`src/render/effects/screenShake.ts`); particle polish and
      camera zoom refinement not done — there's no VFX/particle system yet
- [ ] Menu polish to match art direction (CRT scanlines, chrome, arcade fonts)
      — current UI is a plain dark/blue placeholder kit, not the full MTV-era
      art direction from GAME_DESIGN.md
- [ ] Performance pass against targets (60fps, <500MB, <5s load) — **not
      measured yet, needs an actual device playtest**
- [ ] App Store assets, screenshots, description — not started
- [ ] TestFlight build via EAS — **blocked: needs the user's own Apple
      Developer Program account via `eas login`/`eas submit`. Not something
      to do autonomously.**

---

## Explicitly deferred (stretch goals, not scheduled)
- Create-a-Fighter (selfie → AI-generated character)
- Replay system + auto vertical-video export for social sharing
- Weekly themed events
- Tournament mode (8-player bracket)
- Controller support
- Android port
