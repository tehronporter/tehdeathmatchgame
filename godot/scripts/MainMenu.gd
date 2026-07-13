extends Control
## Main menu — PLAY leads into the match flow.

const UI = preload("res://scripts/UI.gd")

func _ready() -> void:
	UI.fill_bg(self)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	col.custom_minimum_size = Vector2(340, 0)
	center.add_child(col)

	var title := UI.title("DEATHMATCH\nARENA", 48)
	col.add_child(title)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 28)
	col.add_child(gap)

	_btn(col, "PLAY", true, func(): _goto("res://scenes/CharacterSelect.tscn"))
	_btn(col, "MULTIPLAYER", false, Callable())
	_btn(col, "CUSTOMIZE", true, func(): _placeholder("CUSTOMIZE"))
	_btn(col, "SHOP", true, func(): _placeholder("SHOP"))
	_btn(col, "LEADERBOARD", true, func(): _goto("res://scenes/Leaderboard.tscn"))
	_btn(col, "SETTINGS", true, func(): _goto("res://scenes/Settings.tscn"))

func _btn(parent: Node, text: String, enabled: bool, cb: Callable) -> void:
	var b := UI.button(text, enabled)
	if enabled and cb.is_valid():
		b.pressed.connect(cb)
	parent.add_child(b)

func _goto(scene: String) -> void:
	get_tree().change_scene_to_file(scene)

func _placeholder(title: String) -> void:
	MatchConfig.set_meta("placeholder_title", title)
	get_tree().change_scene_to_file("res://scenes/Placeholder.tscn")
