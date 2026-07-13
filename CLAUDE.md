# Deathmatch Arena — Claude Code Project Brain

## What this is
A PS1-nostalgic, physics-based 1v1 arcade fighting game for iOS. Original parody
characters (no licensed celebrities), short 90–180 second matches, dead-simple
controls, over-the-top comedic finishers.

## Read these in order, every new session
1. `docs/PRD.md` — scope, features, success criteria
2. `docs/ARCHITECTURE.md` — tech stack, folder structure, data models. Rendering
   decision is resolved: **Option B** (react-three-fiber + expo-gl + cannon-es).
3. `docs/GAME_DESIGN.md` — characters, arenas, moves, meters, economy
4. `docs/BUILD_PLAN.md` — phased task list. The active phase is the source of truth for
   what to build next. Don't jump ahead to later phases.
5. `docs/PROGRESS.md` — living log: what's done, what's in progress, open decisions.
   Update this after every meaningful chunk of work.
6. `docs/NEXT_STEPS.md` — the authoritative go-forward plan (reference study +
   phased priorities). Start here for "what do I build next."

## Ground rules
- iOS only for now (Expo managed workflow → EAS build → TestFlight).
- No licensed IP, no real celebrity likenesses. Parody archetypes only.
- No pay-to-win. Monetization is cosmetic-only.
- Build a playable local prototype (single device, vs AI, one arena, two
  characters) before touching Supabase, multiplayer, or progression systems.
- Matches: 90–180 seconds.
- Controls: one virtual joystick (movement) + 4 buttons (punch / kick / grab /
  special). Do not add combo inputs, extra buttons, or gestures.
- Visual style: low-poly + modern lighting/animation, real 3D meshes via
  react-three-fiber (not 2D Skia sprites). Don't drift toward realism, and
  don't drift toward "generic mobile game" either.

## Session workflow
1. Check `PROGRESS.md` → current state, next task.
2. Check `BUILD_PLAN.md` → active phase's task list.
3. Do the work.
4. Update `PROGRESS.md`: what changed, what's next, any new decisions/tradeoffs made.
5. If a decision affects architecture (libraries, data model, physics engine),
   record it in PROGRESS.md's Decision Log — don't just make it silently.

## Conventions
- TypeScript everywhere, strict mode on.
- Functional components + hooks only.
- Game logic (physics, state machines, combat resolution) lives in `src/game/`,
  fully decoupled from rendering components in `src/components/` — see
  ARCHITECTURE.md for the split. This matters because it's what makes the
  rendering-engine decision (below) swappable later without a rewrite.
- One phase/task at a time. Don't build multiple BUILD_PLAN phases in one pass.
- No placeholder/mock data left behind silently — if you stub something,
  note it in PROGRESS.md.
