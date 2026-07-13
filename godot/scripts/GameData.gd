extends Node
## Engine-agnostic game data + combat math, ported 1:1 from the old TypeScript
## (src/game/*). This preserves the design across the engine migration.
## Registered as the "GameData" autoload singleton.

# --- Roster (GAME_DESIGN.md: 1-5 stats — Health/Strength/Speed/Special) ---
const ROSTER := [
	{"id": "action-hero", "name": "The Action Hero", "health": 4, "strength": 4, "speed": 3, "special": 3, "color": "1e6bff", "finisher": "meteor-strike"},
	{"id": "wrestler", "name": "The Wrestler", "health": 5, "strength": 5, "speed": 2, "special": 3, "color": "ff2b4d", "finisher": "giant-boot"},
	{"id": "pop-diva", "name": "The Pop Diva", "health": 3, "strength": 2, "speed": 5, "special": 4, "color": "ff4de0", "finisher": "mic-drop"},
	{"id": "tech-billionaire", "name": "The Tech Billionaire", "health": 3, "strength": 2, "speed": 3, "special": 5, "color": "9b59ff", "finisher": "rocket-launch"},
	{"id": "influencer", "name": "The Influencer", "health": 2, "strength": 2, "speed": 5, "special": 3, "color": "ff9d1e", "finisher": "meteor-strike"},
	{"id": "rockstar", "name": "The Rockstar", "health": 4, "strength": 4, "speed": 3, "special": 3, "color": "2eff9d", "finisher": "giant-boot"},
	{"id": "conspiracy-host", "name": "The Conspiracy Host", "health": 3, "strength": 3, "speed": 3, "special": 4, "color": "e0e01e", "finisher": "tnt-pile"},
	{"id": "chef", "name": "The Chef", "health": 4, "strength": 3, "speed": 3, "special": 3, "color": "ff7a1e", "finisher": "knife-throw"},
	{"id": "billionaire", "name": "The Billionaire", "health": 3, "strength": 3, "speed": 2, "special": 5, "color": "c7c7c7", "finisher": "money-cannon"},
	{"id": "super-fan", "name": "The Super Fan", "health": 3, "strength": 3, "speed": 4, "special": 4, "color": "1ee0ff", "finisher": "meteor-strike"},
]

# --- Arenas (each with one interactive hazard) ---
const ARENAS := [
	{"id": "wrestling-ring", "name": "Wrestling Ring", "color": "3a1e1e", "hazard": "thrown-chair", "hazard_ms": 15000, "hazard_damage": 8},
	{"id": "warehouse", "name": "Warehouse", "color": "26261e", "hazard": "explosive-barrel", "hazard_ms": 18000, "hazard_damage": 12},
	{"id": "junkyard", "name": "Junkyard", "color": "1e2a26", "hazard": "magnet-drop", "hazard_ms": 20000, "hazard_damage": 10},
	{"id": "tv-studio", "name": "TV Studio", "color": "1e1e2e", "hazard": "falling-light", "hazard_ms": 16000, "hazard_damage": 9},
	{"id": "vegas-rooftop", "name": "Vegas Rooftop", "color": "2e1e2a", "hazard": "helicopter-wind", "hazard_ms": 17000, "hazard_damage": 6},
	{"id": "construction-site", "name": "Construction Site", "color": "2a2416", "hazard": "falling-pipe", "hazard_ms": 14000, "hazard_damage": 11},
]

# --- Moves (Punch/Kick/Grab/Special) ---
const MOVES := {
	"punch": {"base_damage": 6, "stamina_cost": 8, "hype_gain": 4, "knockback": 1.5, "windup_ms": 150},
	"kick": {"base_damage": 10, "stamina_cost": 14, "hype_gain": 6, "knockback": 3.0, "windup_ms": 300},
	"grab": {"base_damage": 4, "stamina_cost": 18, "hype_gain": 8, "knockback": 5.0, "windup_ms": 400},
	"special": {"base_damage": 20, "stamina_cost": 40, "hype_gain": 15, "knockback": 8.0, "windup_ms": 600},
}

# --- Finishers (per-character; VFX defined in the scene layer) ---
const FINISHERS := {
	"meteor-strike": {"label": "METEOR STRIKE", "camera_zoom": 1.8, "duration_ms": 2200},
	"giant-boot": {"label": "GIANT BOOT", "camera_zoom": 1.6, "duration_ms": 1800},
	"mic-drop": {"label": "MIC DROP", "camera_zoom": 1.5, "duration_ms": 1600},
	"rocket-launch": {"label": "ROCKET LAUNCH", "camera_zoom": 2.0, "duration_ms": 2400},
	"tnt-pile": {"label": "TNT PILE", "camera_zoom": 1.7, "duration_ms": 2000},
	"knife-throw": {"label": "KNIFE THROW", "camera_zoom": 1.4, "duration_ms": 1400},
	"money-cannon": {"label": "MONEY CANNON", "camera_zoom": 1.6, "duration_ms": 1800},
}

func get_character(id: String) -> Dictionary:
	for c in ROSTER:
		if c["id"] == id:
			return c
	push_error("Unknown character id: %s" % id)
	return {}

func get_arena(id: String) -> Dictionary:
	for a in ARENAS:
		if a["id"] == id:
			return a
	push_error("Unknown arena id: %s" % id)
	return {}

## Pure combat resolution (port of resolveMove.ts). Returns damage/cost/hype/kb.
func resolve_move(attacker_strength: int, move_id: String, is_blocking: bool) -> Dictionary:
	var move: Dictionary = MOVES[move_id]
	var strength_mult: float = 0.6 + attacker_strength * 0.15
	var raw_damage: float = float(move["base_damage"]) * strength_mult
	var damage: float = raw_damage * (0.25 if is_blocking else 1.0)
	var knockback: float = float(move["knockback"]) * (0.3 if is_blocking else 1.0)
	return {
		"damage": int(round(damage)),
		"stamina_cost": move["stamina_cost"],
		"hype_gain": move["hype_gain"],
		"knockback": knockback,
	}
