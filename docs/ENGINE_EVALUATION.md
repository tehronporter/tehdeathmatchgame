# Engine Evaluation — Expo/react-three-fiber → Godot 4

Decision date: 2026-07-13. **Verdict: migrate to Godot 4.4+ as the primary
engine.** The game design (PRD/GAME_DESIGN) and the phased roadmap
(NEXT_STEPS) are preserved unchanged — only the implementation stack changes.

## Why we're re-evaluating

The Expo + `react-three-fiber` + `expo-gl` + `cannon-es` stack hit two hard
walls during the prototype:

1. **expo-gl doesn't render on the iOS Simulator.** Its OpenGL ES surface
   never composites — the GL context initializes and three.js issues draw
   calls, but the screen stays pure `#000000`. Every 3D iteration therefore
   requires a full native rebuild onto a *physical device*. For a 3D fighting
   game — where the entire product is the on-screen action — an unviewable-in-
   simulator renderer is disqualifying for fast iteration.
2. **Slow, fragile native loop.** CocoaPods locale bugs, iCloud-sync codesign
   corruption, React codegen races, an ~10-minute native rebuild per native
   change, and hand-rolled `cannon-es` ragdoll tuning through a React bridge.

These are stack problems, not design problems. At Phase 0 the sunk cost is
low, so this is the cheapest point to switch.

## Godot 4.4+ evaluation (for THIS project)

**Strongly in favor:**
- **It renders where expo-gl can't.** Godot 4.4 has a **native Metal renderer**
  for Apple platforms. The iOS Simulator supports Metal, so Godot renders in
  the simulator *and* on device — and, crucially, we can iterate in the
  **desktop editor / macOS export** and skip the iOS toolchain entirely until
  device/TestFlight time. This directly kills wall #1.
- **First-class 3D physics + ragdoll.** **Jolt physics is built into Godot 4.4**
  (no add-on), with native ragdoll via `Skeleton3D` + `PhysicalBone3D` and
  high-detail↔ragdoll skeleton mapping. This is exactly the stumble/knockback/
  KO-ragdoll our PRD wants, and far less hand-rolling than `cannon-es`.
- **Instant iteration.** Press play, see the scene. No bundler, no pods, no
  codegen, no 10-minute rebuild. This is the single biggest win.
- **Purpose-built for the rest of the game too:** particles/VFX (finishers),
  camera + screen shake, `AnimationPlayer`, a full `Control`-node UI system
  (the MTV chrome HUD/menus/VS screen), audio buses (crowd/announcer/SFX).
- **Retro low-poly is a sweet spot.** PS1-style vertex-snap/affine shaders are
  a well-trodden path in Godot; the "PS1 nostalgic" look is natural here.
- **iOS export is a supported target** (generates an Xcode project) and
  **licensing is MIT** — no per-title/runtime fees, ideal for an indie title.

**Costs / honest cons:**
- **It's a reimplementation.** The Expo app, RN screens, r3f scene, and
  `cannon-es` code are discarded. Mitigant: our TypeScript **game logic is a
  spec, not a loss** — `resolveMove`, the AI profiles, and all
  character/arena/finisher **data** port directly to GDScript + Godot
  Resources. The *design* carries over 1:1.
- **New language (GDScript).** Python-like, fast to learn and to generate.
  (C# is also supported if preferred; GDScript recommended for iteration speed.)
- **Backend re-integration.** Supabase moves from `@supabase/supabase-js` to
  Godot `HTTPRequest` + `WebSocketPeer` (REST + Realtime) — community
  Supabase-Godot plugins exist. Still Phase-6/post-prototype; not blocked.
- **Same iOS ship prerequisites.** Device testing + TestFlight still need Xcode
  and your Apple Developer account (unchanged from before).

## What's preserved vs replaced

| Preserved (engine-agnostic) | Replaced |
|---|---|
| PRD.md, GAME_DESIGN.md, NEXT_STEPS.md — vision, roster, arenas, finishers, meters, economy, art direction | Expo/React Native app shell |
| The phased roadmap (remapped below, same goals) | `react-three-fiber` + `expo-gl` scene |
| Combat math, stat spreads, AI behavior *as a spec* | `cannon-es` physics → Jolt |
| Character/arena/finisher **data** → Godot Resources | RN `Control`-less UI → Godot `Control` nodes |
| Two-stage KO design (from the Celebrity Deathmatch study) | Zustand stores → Godot autoload singletons |

## Roadmap remap (same goals, Godot phases)

- **G0 — New foundation:** Godot 4.4+ project, iOS + macOS export presets,
  Jolt enabled, folder structure mirroring `src/game` (characters, arenas,
  combat, ai, finishers as Resources/scripts), a lit test scene rendering a
  primitive fighter — the smoke test the old stack failed.
- **G1 — Core match (was NEXT_STEPS Phase 0+1):** side-view 2.5D ring camera,
  ring geometry, a `PhysicalBone3D` ragdoll fighter responding to input,
  `resolveMove` port, live Health/Stamina/Hype, two-stage KO.
- **G2 — Presentation (Phase 2):** portrait character select, VS screen,
  MTV-chrome HUD, results payoff, announcer barks — all Godot `Control` UI.
- **G3 — Identity (Phase 3):** oversized-head low-poly fighters, arena
  dressing + crowd + lighting, interactive hazards.
- **G4 — Juice & finishers (Phase 4):** finisher sequences (camera/slow-mo/
  particles), hit sparks, ragdoll-on-KO, crowd/announcer reactions.
- **G5 — Art direction (Phase 5):** PS1 shader pass, CRT/chrome UI skin.
- **G6 — Content & systems (Phase 6):** full roster/arenas, 4 AI tiers, career,
  shop, sound pass.
- **G7 — Assets & ship (Phase 7):** real low-poly models, Supabase via
  HTTP/WebSocket, iOS export → TestFlight (your Apple Developer account).

## Verify workflow after the switch
Run the Godot **macOS build / editor** and capture screenshots to verify
gameplay and rendering — no iOS Simulator dependency for day-to-day iteration.
Export to iOS only for on-device + TestFlight checks. This is a *faster* and
more reliable verify loop than the old stack, not just a lateral move.

## Sources
- [Godot 4.4 release notes (Metal renderer, Jolt integration)](https://godotengine.org/releases/4.4/)
- [Using Jolt Physics — Godot docs](https://docs.godotengine.org/en/stable/tutorials/physics/using_jolt_physics.html)
- [Godot 4.4 released: Jolt, .NET 8 (devclass)](https://devclass.com/2025/03/05/godot-4-4-released-open-source-game-engine-adds-jolt-physics-net-8-and-more/)
