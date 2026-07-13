# Architecture — Deathmatch Arena

## ⚠️ Open decision: rendering & physics engine (read before Phase 1)

The original stack notes list **React Native Skia** for rendering and
**Matter.js** for physics. Worth being direct about this: Skia is a 2D canvas
API and Matter.js is a 2D physics engine. Neither natively produces 3D
low-poly meshes, camera-relative depth, or 3D ragdoll physics. If "PS1
low-poly 3D characters" is taken literally, this stack can't do it as-is.

There are three real paths. Pick one before writing any combat/rendering code
— it changes the folder structure, the data model for character rigs, and
the physics layer.

**Option A — 2.5D fake-3D (fastest to build, matches "arcade" priority)**
Render everything as flattened/angled 2D vector or sprite art with Skia;
fake depth with layering, scale, and shadow tricks (think Power Stone's UI
energy but Streets-of-Rage-style depth). Physics stays 2D via Matter.js.
Fastest path to a playable prototype in Expo/JS. Visual style reads as
"stylized 2D" more than "3D PS1," even with good lighting tricks.

**Option B — True 3D low-poly (closest to the stated vision)**
Use `expo-gl` + `react-three-fiber` (three.js) for real 3D meshes, characters,
camera, and lighting. Swap Matter.js for a 3D-capable physics engine —
`cannon-es` (pure JS, easiest to integrate) or `@dimforge/rapier3d` (faster,
WASM, more setup). This is the option that actually delivers "PS1 3D fighter
with ragdoll physics." More setup cost, asset pipeline needs real low-poly
character models (not just sprites), heavier lift for the character
customization/create-a-fighter stretch goal, but is a straight line to the
stated vision.

**Option C — Native engine (Godot / Unity)**
Outside a pure Claude-Code-in-a-repo JS workflow; better native fit for real
3D low-poly + ragdoll, but breaks from the Expo/Supabase stack and the "build
it in Claude Code as a JS project" workflow implied by the rest of this PRD.

**Recommendation for this project:** Option B. It's the only path that
actually matches "PS1 3D low-poly + modern lighting + ragdoll physics," and
`react-three-fiber` + `expo-gl` still runs inside an Expo app, so the rest of
the stack (Supabase, Expo Router, EAS build) is unaffected. Matter.js is
dropped in favor of `cannon-es` for the physics layer. This doc assumes
Option B below; if you decide otherwise, update this file and PROGRESS.md's
Decision Log before starting Phase 2.

---

## 1. Tech stack

**Client**
- Expo (managed workflow, EAS Build for TestFlight)
- Expo Router for navigation
- `expo-gl` + `react-three-fiber` + `three` for 3D rendering
- `cannon-es` for 3D physics (ragdoll, knockback, collisions)
- `react-native-reanimated` for UI-layer animation (HUD, menus, meters)
- Zustand (or similar) for client state
- `expo-av` for audio

**Backend (post-prototype)**
- Supabase: auth, Postgres (player profiles, stats, cosmetics), Realtime
  (matchmaking/multiplayer), Storage (cosmetics assets, replay clips)

**Deployment**
- iOS only for MVP, via EAS Build → TestFlight
- Android deferred

## 2. Folder structure

```
deathmatch-arena/
  app/                          # Expo Router screens
    (menu)/
      index.tsx                 # Main menu
      customize.tsx
      shop.tsx
      leaderboard.tsx
      settings.tsx
    match/
      character-select.tsx
      fight.tsx
      results.tsx
  src/
    game/                       # pure game logic, no React/rendering imports
      engine/                   # game loop, tick/update scheduling
      physics/                  # cannon-es world setup, bodies, collision handlers
      characters/                # character stat definitions, movesets
      arenas/                     # arena definitions, hazard trigger logic
      combat/                      # move resolution, hit/hurtboxes, damage calc
      ai/                           # AI opponent behavior per difficulty tier
      finishers/                     # finisher trigger conditions + sequences
    render/                      # react-three-fiber scene, meshes, camera, lighting
      scenes/
      characters/                 # 3D character components (mesh + rig binding)
      arenas/
      effects/                    # particles, screen shake, finisher VFX
    components/
      ui/                        # buttons, joystick, meters, menus (Reanimated)
      hud/                       # in-match HUD (health/stamina/hype bars)
    state/
      matchStore.ts
      playerStore.ts
    supabase/                    # not used until Phase 5
      client.ts
      auth.ts
      matchmaking.ts
      leaderboard.ts
      cosmetics.ts
    audio/
    assets/
      models/                    # .glb/.gltf low-poly character + arena models
      textures/
      sfx/
      music/
  supabase/
    migrations/
  CLAUDE.md
  PRD.md
  ARCHITECTURE.md
  GAME_DESIGN.md
  BUILD_PLAN.md
  PROGRESS.md
```

Key rule: `src/game/` never imports from `src/render/` or React. Game logic
runs and is testable independent of rendering — this is what makes the
Option A/B/C decision above swappable later without a full rewrite, and makes
AI opponents and combat resolution unit-testable without a rendered scene.

## 3. Core systems

**Game loop** — fixed-timestep update in `src/game/engine`, decoupled from
React's render cycle. Physics steps at a fixed rate; rendering interpolates.

**Physics** — `cannon-es` world holds fighter rigid bodies (simplified
capsule/box colliders per limb for ragdoll, not full mesh collision),
arena geometry, and hazard objects. Each fighter is a small ragdoll rig with
constraints (joints) between body parts so hits produce believable stumble/
knockback without full inverse kinematics.

**Combat resolution** — punch/kick/grab/special map to hitbox activation
windows on a per-character-frame-data basis. Damage, stamina cost, and hype
gain are pure functions in `src/game/combat`, taking (attacker stats, move,
defender state) → result. No physics or rendering side effects live here.

**AI** — 4 difficulty tiers (Easy/Medium/Hard/Nightmare) as behavior profiles:
reaction time, block/dodge probability, move selection weighting. Lives in
`src/game/ai`, consumes the same combat resolution functions as a human input
source would.

**Finishers** — triggered by Hype meter threshold + player input, or by arena
hazard timers. A finisher is a scripted sequence (camera zoom → VFX/hazard
event → forced match end) defined per-arena or per-character in
`src/game/finishers`.

**Audio** — crowd cheers reactive to hits/Hype level, announcer barks,
impact SFX, arcade music bed. `expo-av`, triggered from game events, not
polled from render loop.

## 4. Data models (TypeScript, prototype scope)

```typescript
interface CharacterStats {
  health: number;
  strength: number;
  speed: number;
  special: number;
}

interface Character {
  id: string;
  name: string;               // parody archetype name
  stats: CharacterStats;
  modelPath: string;           // low-poly .glb asset
  moveset: MoveId[];
  finisherId: string;
}

interface Arena {
  id: string;
  name: string;
  modelPath: string;
  hazards: HazardDefinition[];
}

interface HazardDefinition {
  id: string;
  triggerType: 'timer' | 'hypeThreshold' | 'random';
  effect: string;               // references a finisher/event script
}

interface MatchState {
  arenaId: string;
  fighters: [FighterState, FighterState];
  timeElapsed: number;
  status: 'countdown' | 'active' | 'finisher' | 'ended';
}

interface FighterState {
  characterId: string;
  health: number;
  stamina: number;
  hype: number;
  position: Vector3;
  ragdollActive: boolean;
}
```

## 5. Supabase schema (post-prototype, Phase 5)

```sql
profiles (id, username, created_at, xp, level, coins)
characters_unlocked (profile_id, character_id, unlocked_at)
cosmetics_owned (profile_id, cosmetic_id, unlocked_at)
matches (id, player_a, player_b, winner, arena_id, duration, created_at)
leaderboard (profile_id, rank, wins, season)
achievements (profile_id, achievement_id, earned_at)
```

Not needed until Phase 5 (Online). Don't scaffold Supabase tables/auth before
the local prototype (Phases 1–3) is working — see BUILD_PLAN.md.

## 6. Performance targets
- 60 FPS gameplay on iPhone SE and up
- Under 500MB install
- Cold load under 5 seconds
- Low-poly budget: 500–1,500 tris per character to keep this achievable on
  older supported devices
