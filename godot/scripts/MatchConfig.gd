extends Node
## Autoload: the selections carried Menu → Character Select → VS → Fight → Results.

var player_id := "action-hero"
var opponent_id := "wrestler"
var arena_id := "wrestling-ring"
var difficulty := "medium" # easy | medium | hard | nightmare

var last_winner := -1 # 0 = player, 1 = opponent, -1 = none yet
var last_finisher_used := false

func player() -> Dictionary:
	return GameData.get_character(player_id)

func opponent() -> Dictionary:
	return GameData.get_character(opponent_id)

func arena() -> Dictionary:
	return GameData.get_arena(arena_id)

## Pick a random opponent that isn't the player.
func randomize_opponent() -> void:
	var pool := GameData.ROSTER.filter(func(c): return c["id"] != player_id)
	opponent_id = pool[randi() % pool.size()]["id"]

## Pick a random arena for variety.
func randomize_arena() -> void:
	arena_id = GameData.ARENAS[randi() % GameData.ARENAS.size()]["id"]
