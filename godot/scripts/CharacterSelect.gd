extends Control
## Portrait-card roster select. Sets MatchConfig.player_id, then → VS.

const UI = preload("res://scripts/UI.gd")

var _cards := {} # id -> PanelContainer

func _ready() -> void:
	UI.fill_bg(self)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for m in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + m, 24)
	add_child(margin)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 14)
	margin.add_child(col)

	col.add_child(UI.title("CHOOSE YOUR FIGHTER", 26))

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	col.add_child(scroll)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(grid)

	for c in GameData.ROSTER:
		grid.add_child(_make_card(c))

	var enter := UI.button("ENTER ARENA")
	enter.pressed.connect(_on_enter)
	col.add_child(enter)
	var back := UI.button("BACK")
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	col.add_child(back)

	_select(MatchConfig.player_id)

func _make_card(c: Dictionary) -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 150)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	panel.gui_input.connect(func(e): _on_card_input(e, c["id"]))

	var v := VBoxContainer.new()
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	v.add_theme_constant_override("separation", 6)
	panel.add_child(v)

	var wrap := CenterContainer.new()
	v.add_child(wrap)
	var swatch := Panel.new()
	swatch.custom_minimum_size = Vector2(54, 54)
	var ss := StyleBoxFlat.new()
	ss.bg_color = Color(c["color"])
	ss.set_corner_radius_all(27)
	swatch.add_theme_stylebox_override("panel", ss)
	wrap.add_child(swatch)

	var nm := UI.label(c["name"], 13)
	nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nm.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(nm)

	var stats := UI.label("H%d  S%d  SP%d  SPC%d" % [c["health"], c["strength"], c["speed"], c["special"]], 10, UI.DIM)
	stats.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(stats)

	_cards[c["id"]] = panel
	return panel

func _on_card_input(e: InputEvent, id: String) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		_select(id)

func _select(id: String) -> void:
	MatchConfig.player_id = id
	for cid in _cards:
		if cid == id:
			_cards[cid].add_theme_stylebox_override("panel", UI.panel_style(Color(GameData.get_character(cid)["color"]), UI.PANEL, 3))
		else:
			_cards[cid].add_theme_stylebox_override("panel", UI.panel_style(UI.CHROME, UI.PANEL, 2))

func _on_enter() -> void:
	MatchConfig.randomize_opponent()
	get_tree().change_scene_to_file("res://scenes/VS.tscn")
