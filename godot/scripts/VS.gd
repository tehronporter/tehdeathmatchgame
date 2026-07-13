extends Control
## The VS beat: 1P vs CPU big portraits, arena, FIGHT.

const UI = preload("res://scripts/UI.gd")

func _ready() -> void:
	UI.fill_bg(self)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 22)
	col.custom_minimum_size = Vector2(360, 0)
	center.add_child(col)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 16)
	col.add_child(row)
	row.add_child(_portrait(MatchConfig.player(), "1P"))
	var vs := UI.title("VS", 46)
	vs.add_theme_color_override("font_color", UI.ACCENT)
	row.add_child(vs)
	row.add_child(_portrait(MatchConfig.opponent(), "CPU"))

	var arena := UI.label("ARENA:  %s" % MatchConfig.arena()["name"], 16, UI.DIM)
	arena.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	col.add_child(arena)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 12)
	col.add_child(gap)

	var fight := UI.button("FIGHT")
	fight.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/Fight.tscn"))
	col.add_child(fight)
	var back := UI.button("BACK")
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn"))
	col.add_child(back)

func _portrait(c: Dictionary, tag: String) -> Control:
	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 8)
	v.custom_minimum_size = Vector2(140, 0)

	var tagl := UI.label(tag, 16, UI.ACCENT)
	tagl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(tagl)

	var wrap := CenterContainer.new()
	v.add_child(wrap)
	var swatch := Panel.new()
	swatch.custom_minimum_size = Vector2(120, 120)
	var ss := StyleBoxFlat.new()
	ss.bg_color = Color(c["color"])
	ss.set_corner_radius_all(60)
	ss.border_color = UI.CHROME
	ss.set_border_width_all(3)
	swatch.add_theme_stylebox_override("panel", ss)
	wrap.add_child(swatch)

	var nm := UI.label(c["name"], 15)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nm.custom_minimum_size = Vector2(140, 0)
	v.add_child(nm)
	return v
