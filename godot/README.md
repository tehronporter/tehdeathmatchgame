# Deathmatch Arena — Godot 4 project

PS1-nostalgic, physics-flavoured 1v1 arcade fighter. Godot 4.7. Original parody
archetypes only (no licensed likenesses). See `../docs/` for design + roadmap;
`../docs/ENGINE_EVALUATION.md` explains the migration off Expo/react-three-fiber.

## Run (desktop)
```bash
godot --path .                 # opens the game (main scene = Main Menu)
```
On Apple Silicon the default Vulkan/Metal path works. On this Intel Mac
MoltenVK's compute path is broken, so use the GL-compatibility renderer:
```bash
godot --path . --rendering-method gl_compatibility --rendering-driver opengl3
```

## Verify (headless screenshot of any screen)
```bash
./verify.sh out.png                                   # main scene
godot --path . --rendering-method gl_compatibility --rendering-driver opengl3 \
  -- --goto res://scenes/Fight.tscn --debug mid --screenshot out.png
```
`--goto <scene>` jumps to a screen; `--debug mid|ko|finish` sets up a Fight
state; `--screenshot <path>` renders a few frames, saves, and quits.

## Controls
- Move: on-screen joystick (bottom-left) or A/D / ←→.
- Attacks: P/K/G/S buttons (bottom-right) or J/K/L/I (or 1-4).

## Structure
```
project.godot         # autoloads: GameData, MatchConfig, PlayerProfile, Audio, CRT, Shot
scenes/               # MainMenu, CharacterSelect, VS, Fight, Results, Settings, Leaderboard
scripts/
  GameData.gd         # roster/arenas/moves/finishers + resolve_move (engine-agnostic)
  Fight.gd, Fighter.gd# the match: ring, combat, AI, HUD, two-stage KO/finisher
  UI.gd               # shared MTV-chrome UI helpers
  PlayerProfile.gd    # persisted progression (user://profile.json)
  Audio.gd, CRT.gd    # SFX/crowd, scanline overlay
assets/sfx/           # procedural WAVs
```

## iOS ship (not yet done — needs your credentials)
Install Godot's iOS export templates, then Project → Export → iOS. Signing +
TestFlight require your Apple Developer account. The mobile/Metal renderer is
used on device (unaffected by the desktop MoltenVK issue above).
