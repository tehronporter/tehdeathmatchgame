extends Control
## Generic "coming soon" screen for not-yet-built menu destinations.

const UI = preload("res://scripts/UI.gd")

func _ready() -> void:
	UI.fill_bg(self)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 18)
	col.custom_minimum_size = Vector2(300, 0)
	center.add_child(col)
	var t: String = MatchConfig.get_meta("placeholder_title", "COMING SOON")
	col.add_child(UI.title(t, 30))
	var sub := UI.label("Coming post-prototype.", 14, UI.DIM)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(sub)
	var back := UI.button("BACK")
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	col.add_child(back)
