extends Node
## Autoload: local progression, persisted to user://profile.json.
## Ported from the old playerStore.ts (XP/level/coins/achievements/dailies).

const PATH := "user://profile.json"
const XP_PER_LEVEL := 500

var xp := 0
var level := 1
var coins := 0
var wins := 0
var punches := 0
var finishers := 0
var streak := 0
var achievements := {} # id -> earned(bool)
var dailies := {}       # id -> {label, target, progress}

const ACHV := {
	"first-win": "First Win",
	"hundred-wins": "100 Wins",
	"first-finisher": "First Finisher",
	"five-hundred-punches": "500 Punches",
}

func _ready() -> void:
	_load()

func _defaults() -> void:
	for id in ACHV:
		if not achievements.has(id):
			achievements[id] = false
	if dailies.is_empty():
		dailies = {
			"win-3": {"label": "Win 3 matches", "target": 3, "progress": 0},
			"land-100-punches": {"label": "Land 100 punches", "target": 100, "progress": 0},
			"perform-5-finishers": {"label": "Perform 5 finishers", "target": 5, "progress": 0},
		}

func record_win(finisher_used: bool) -> void:
	xp += 100
	level = xp / XP_PER_LEVEL + 1
	coins += 25
	wins += 1
	streak += 1
	if finisher_used:
		finishers += 1
	if wins >= 1:
		achievements["first-win"] = true
	if wins >= 100:
		achievements["hundred-wins"] = true
	if finishers >= 1:
		achievements["first-finisher"] = true
	_bump("win-3", 1)
	if finisher_used:
		_bump("perform-5-finishers", 1)
	_save()

func record_loss() -> void:
	streak = 0
	_save()

func record_punch() -> void:
	punches += 1
	if punches >= 500:
		achievements["five-hundred-punches"] = true
	_bump("land-100-punches", 1)

func _bump(id: String, amount: int) -> void:
	if dailies.has(id):
		var d: Dictionary = dailies[id]
		d["progress"] = min(int(d["target"]), int(d["progress"]) + amount)

func _load() -> void:
	if FileAccess.file_exists(PATH):
		var f := FileAccess.open(PATH, FileAccess.READ)
		var data = JSON.parse_string(f.get_as_text())
		if data is Dictionary:
			xp = int(data.get("xp", 0))
			level = int(data.get("level", 1))
			coins = int(data.get("coins", 0))
			wins = int(data.get("wins", 0))
			punches = int(data.get("punches", 0))
			finishers = int(data.get("finishers", 0))
			streak = int(data.get("streak", 0))
			achievements = data.get("achievements", {})
			dailies = data.get("dailies", {})
	_defaults()

func _save() -> void:
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	if f == null:
		return
	f.store_string(JSON.stringify({
		"xp": xp, "level": level, "coins": coins, "wins": wins,
		"punches": punches, "finishers": finishers, "streak": streak,
		"achievements": achievements, "dailies": dailies,
	}))
