extends Control
## Difficulty selection (real: feeds AI reaction time in Fight).

const UI = preload("res://scripts/UI.gd")
const LEVELS := ["easy", "medium", "hard", "nightmare"]

var _buttons := {}

func _ready() -> void:
	UI.fill_bg(self)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 12)
	col.custom_minimum_size = Vector2(320, 0)
	center.add_child(col)

	col.add_child(UI.title("SETTINGS", 30))
	var sub := UI.label("AI DIFFICULTY", 14, UI.DIM)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(sub)

	for d in LEVELS:
		var b := UI.button(d.to_upper())
		b.pressed.connect(func(): _select(d))
		_buttons[d] = b
		col.add_child(b)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 12)
	col.add_child(gap)
	var back := UI.button("BACK")
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	col.add_child(back)

	_refresh()

func _select(d: String) -> void:
	MatchConfig.difficulty = d
	_refresh()

func _refresh() -> void:
	for d in _buttons:
		var selected: bool = d == MatchConfig.difficulty
		_buttons[d].add_theme_stylebox_override("normal", UI.panel_style(UI.ACCENT if selected else UI.CHROME, UI.PANEL, 3 if selected else 2))
