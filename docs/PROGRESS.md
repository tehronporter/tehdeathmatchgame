# Progress — Deathmatch Arena

Update this file at the end of every session. Keep entries short — this is a
status board, not a diary.

## Current phase
Phase 0 — Repo setup (in progress)

## Completed
- Repo cleanup: fixed trailing-space docs folder name, dropped .DS_Store,
  moved CLAUDE.md to repo root.

## In progress
- Phase 0 repo setup (create-expo-app, dependencies, placeholder screens).

## Next up
- Finish Phase 0 checklist, then Phase 1 (fixed-timestep loop, physics smoke test).

## Open decisions
- **3D asset pipeline is unresolved.** No character/arena `.glb` models exist
  and no plan to source them yet. Phases 0-2 will use primitive placeholder
  geometry (capsules/boxes) per BUILD_PLAN's own Phase 1 smoke test — this is
  fine through Phase 2, but Phase 3 ("build 2 characters," "build 1 arena")
  needs a real answer (commission art, use a marketplace asset pack, or
  generate low-poly meshes) before it can be considered done.

## Decision log
| Date | Decision | Why |
|---|---|---|
| 2026-07-13 | Rendering/physics stack: Option B (react-three-fiber + expo-gl + cannon-es) | User confirmed going with the documented recommendation; dev machine has Xcode 26.3 + simulator ready, so the slower native iteration loop is acceptable. |
