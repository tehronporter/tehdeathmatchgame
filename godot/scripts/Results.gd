extends Control
## Post-match payoff.

const UI = preload("res://scripts/UI.gd")

func _ready() -> void:
	# Record the result once (skip when opened directly for a screenshot).
	if MatchConfig.last_winner == 0:
		PlayerProfile.record_win(MatchConfig.last_finisher_used)
	elif MatchConfig.last_winner == 1:
		PlayerProfile.record_loss()
	UI.fill_bg(self)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var col := VBoxContainer.new()
	col.alignment = BoxContainer.ALIGNMENT_CENTER
	col.add_theme_constant_override("separation", 18)
	col.custom_minimum_size = Vector2(340, 0)
	center.add_child(col)

	var winner := MatchConfig.player() if MatchConfig.last_winner == 0 else MatchConfig.opponent()
	var wrap := CenterContainer.new()
	col.add_child(wrap)
	var swatch := Panel.new()
	swatch.custom_minimum_size = Vector2(110, 110)
	var ss := StyleBoxFlat.new()
	ss.bg_color = Color(winner["color"])
	ss.set_corner_radius_all(55)
	ss.border_color = UI.ACCENT
	ss.set_border_width_all(3)
	swatch.add_theme_stylebox_override("panel", ss)
	wrap.add_child(swatch)

	col.add_child(UI.title("%s WINS" % winner["name"], 30))

	if MatchConfig.last_finisher_used:
		var fin: Dictionary = GameData.FINISHERS[winner["finisher"]]
		var f := UI.label("FINISHER:  %s" % fin["label"], 15, UI.ACCENT)
		f.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		col.add_child(f)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 12)
	col.add_child(gap)

	var again := UI.button("PLAY AGAIN")
	again.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn"))
	col.add_child(again)
	var menu := UI.button("MAIN MENU")
	menu.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	col.add_child(menu)
