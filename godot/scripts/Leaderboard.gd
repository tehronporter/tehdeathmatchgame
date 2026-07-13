extends Control
## Local progression board: profile stats, daily challenges, achievements.

const UI = preload("res://scripts/UI.gd")

func _ready() -> void:
	UI.fill_bg(self)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for m in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + m, 28)
	add_child(margin)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 10)
	margin.add_child(col)

	col.add_child(UI.title("LEADERBOARD", 28))

	var summary := UI.label("Level %d   ·   %d wins   ·   %d streak   ·   %d coins" % [
		PlayerProfile.level, PlayerProfile.wins, PlayerProfile.streak, PlayerProfile.coins], 15)
	col.add_child(summary)

	col.add_child(_section("DAILY CHALLENGES"))
	for id in PlayerProfile.dailies:
		var d: Dictionary = PlayerProfile.dailies[id]
		var done: bool = int(d["progress"]) >= int(d["target"])
		col.add_child(UI.label("%s  %s (%d/%d)" % ["[x]" if done else "[ ]", d["label"], int(d["progress"]), int(d["target"])], 13, UI.TEXT if done else UI.DIM))

	col.add_child(_section("ACHIEVEMENTS"))
	for id in PlayerProfile.ACHV:
		var earned: bool = PlayerProfile.achievements.get(id, false)
		col.add_child(UI.label("%s  %s" % ["[x]" if earned else "[ ]", PlayerProfile.ACHV[id]], 13, UI.TEXT if earned else UI.DIM))

	var gap := Control.new()
	gap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	col.add_child(gap)
	var back := UI.button("BACK")
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	col.add_child(back)

func _section(text: String) -> Label:
	var l := UI.label(text, 15, UI.ACCENT)
	return l
