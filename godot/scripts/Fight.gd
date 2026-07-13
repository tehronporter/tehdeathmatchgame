extends Node3D
## The match: 2.5D ring, two fighters, combat wired to GameData.resolve_move,
## AI opponent, live HUD, hazards, and the two-stage KO/finisher.

const UI = preload("res://scripts/UI.gd")
const FighterScript = preload("res://scripts/Fighter.gd")

const RING_HALF := 3.6
const ATTACK_RANGE := 2.4
const HAZARD_HALF := 1.5

const AI_REACTION := {"easy": 0.9, "medium": 0.55, "hard": 0.35, "nightmare": 0.18}
const KEY_MOVES := ["punch", "kick", "grab", "special"]

var player: Node3D
var opponent: Node3D
var camera: Camera3D
var state := "active"

var move_x := 0.0
var stick_x := 0.0
var pending := ""
var ai_cd := 0.0
var hazard_ms := 0.0

# HUD refs
var p_bars := {}
var o_bars := {}
var banner: Label
var finish_hint: Label
var audio: Node

func _ready() -> void:
	randomize()
	audio = get_node_or_null("/root/Audio")
	_build_world()
	_spawn_fighters()
	_build_hud()
	_build_controls()
	hazard_ms = 0.0
	if audio:
		audio.start_crowd()
	_apply_debug()

# ---------------------------------------------------------------- world

func _build_world() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(MatchConfig.arena()["color"])
	env.ambient_light_color = Color.WHITE
	env.ambient_light_energy = 0.5
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)

	camera = Camera3D.new()
	camera.position = Vector3(0, 3.2, 9.6)
	camera.fov = 52
	add_child(camera)
	camera.look_at(Vector3(0, 1.2, 0), Vector3.UP)

	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-50, -30, 0)
	key.light_energy = 1.3
	key.shadow_enabled = true
	add_child(key)

	# Ring floor
	_add_box(Vector3(10, 0.3, 7), Vector3(0, -0.15, 0), Color("101014"))
	# Corner posts
	for sx in [-1, 1]:
		for sz in [-1, 1]:
			_add_box(Vector3(0.28, 2.2, 0.28), Vector3(sx * 4.6, 1.0, sz * 3.0), Color("cc3a1a"))
	# Ropes (back solid, front thin) — orange like the reference
	for h in [0.7, 1.2, 1.7]:
		_add_box(Vector3(9.2, 0.06, 0.06), Vector3(0, h, -3.0), Color("d0d0d0"))
		_add_box(Vector3(9.2, 0.04, 0.04), Vector3(0, h, 3.0), Color("d0d0d0"))
	_build_crowd()

func _build_crowd() -> void:
	# Cheap crowd: rows of small dim boxes behind the ring.
	var palette := [Color("2a2f45"), Color("3a2a2a"), Color("2a3a2f"), Color("332a3a")]
	for row in range(3):
		var z := -5.0 - row * 1.1
		var y := 0.4 + row * 0.7
		for i in range(24):
			var x := -11.0 + i * 0.95 + randf_range(-0.15, 0.15)
			var c: Color = palette[randi() % palette.size()].lightened(randf_range(0.0, 0.25))
			_add_box(Vector3(0.5, 0.9, 0.5), Vector3(x, y, z), c)

func _add_box(size: Vector3, pos: Vector3, color: Color) -> void:
	var m := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	m.mesh = bm
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	m.material_override = mat
	m.position = pos
	add_child(m)

func _spawn_fighters() -> void:
	player = FighterScript.new()
	add_child(player)
	player.setup(MatchConfig.player(), true, 1.0)
	player.position = Vector3(-1.6, 0, 0)

	opponent = FighterScript.new()
	add_child(opponent)
	opponent.setup(MatchConfig.opponent(), false, -1.0)
	opponent.position = Vector3(1.6, 0, 0)

# ---------------------------------------------------------------- HUD

func _build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	var top := HBoxContainer.new()
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.offset_top = 20
	top.offset_left = 16
	top.offset_right = -16
	top.add_theme_constant_override("separation", 24)
	layer.add_child(top)

	top.add_child(_fighter_hud(MatchConfig.player(), p_bars, false))
	top.add_child(_fighter_hud(MatchConfig.opponent(), o_bars, true))

	banner = UI.title("", 64)
	banner.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	banner.add_theme_color_override("font_color", UI.ACCENT)
	banner.visible = false
	layer.add_child(banner)

	finish_hint = UI.title("FINISH!", 34)
	finish_hint.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	finish_hint.offset_top = 120
	finish_hint.add_theme_color_override("font_color", UI.HEALTH)
	finish_hint.visible = false
	layer.add_child(finish_hint)

func _fighter_hud(c: Dictionary, store: Dictionary, mirror: bool) -> Control:
	var v := VBoxContainer.new()
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	v.add_theme_constant_override("separation", 3)
	var nm := UI.label(c["name"], 15)
	if mirror:
		nm.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	v.add_child(nm)
	store["health"] = _meter(UI.HEALTH)
	store["stamina"] = _meter(UI.STAMINA)
	store["hype"] = _meter(UI.HYPE)
	v.add_child(store["health"])
	v.add_child(store["stamina"])
	v.add_child(store["hype"])
	return v

func _meter(color: Color) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0
	p.max_value = 100
	p.value = 100
	p.show_percentage = false
	p.custom_minimum_size = Vector2(0, 12)
	var bg := StyleBoxFlat.new()
	bg.bg_color = UI.PANEL
	bg.border_color = UI.CHROME
	bg.set_border_width_all(1)
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	p.add_theme_stylebox_override("background", bg)
	p.add_theme_stylebox_override("fill", fill)
	return p

# ---------------------------------------------------------------- controls

func _build_controls() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)

	# Virtual joystick (bottom-left)
	var base := Panel.new()
	base.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	base.position = Vector2(28, -160)
	base.custom_minimum_size = Vector2(150, 130)
	base.size = Vector2(150, 130)
	var bs := StyleBoxFlat.new()
	bs.bg_color = UI.PANEL
	bs.border_color = UI.CHROME
	bs.set_border_width_all(2)
	bs.set_corner_radius_all(14)
	base.add_theme_stylebox_override("panel", bs)
	base.gui_input.connect(_on_stick_input)
	layer.add_child(base)
	var knob := Panel.new()
	knob.name = "knob"
	knob.position = Vector2(53, 43)
	knob.custom_minimum_size = Vector2(44, 44)
	knob.size = Vector2(44, 44)
	var ks := StyleBoxFlat.new()
	ks.bg_color = UI.ACCENT
	ks.set_corner_radius_all(22)
	knob.add_theme_stylebox_override("panel", ks)
	knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	base.add_child(knob)

	# Action buttons (bottom-right)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	grid.position = Vector2(-190, -190)
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	layer.add_child(grid)
	for m in [["punch", "P"], ["kick", "K"], ["grab", "G"], ["special", "S"]]:
		grid.add_child(_action_button(m[0], m[1]))

func _action_button(move_id: String, letter: String) -> Button:
	var b := Button.new()
	b.text = letter
	b.custom_minimum_size = Vector2(76, 76)
	b.add_theme_font_size_override("font_size", 26)
	b.add_theme_color_override("font_color", UI.TEXT)
	var s := StyleBoxFlat.new()
	s.bg_color = UI.PANEL
	s.border_color = UI.CHROME
	s.set_border_width_all(2)
	s.set_corner_radius_all(38)
	b.add_theme_stylebox_override("normal", s)
	var sp := StyleBoxFlat.new()
	sp.bg_color = UI.ACCENT
	sp.set_corner_radius_all(38)
	b.add_theme_stylebox_override("pressed", sp)
	b.pressed.connect(func(): pending = move_id)
	return b

func _on_stick_input(e: InputEvent) -> void:
	var knob: Panel = get_node_or_null("../CanvasLayer2")
	if e is InputEventMouseButton and not e.pressed:
		stick_x = 0.0
		return
	if (e is InputEventMouseMotion and (e.button_mask & MOUSE_BUTTON_MASK_LEFT)) or (e is InputEventMouseButton and e.pressed):
		var local_x: float = e.position.x - 75.0
		stick_x = clamp(local_x / 55.0, -1.0, 1.0)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_J, KEY_1: pending = "punch"
			KEY_K, KEY_2: pending = "kick"
			KEY_L, KEY_3: pending = "grab"
			KEY_I, KEY_4: pending = "special"

# ---------------------------------------------------------------- loop

func _process(delta: float) -> void:
	player.tick(delta)
	opponent.tick(delta)
	_update_hud()
	if state != "active":
		return

	_handle_player(delta)
	_handle_ai(delta)
	player.face_toward(opponent.global_position.x)
	opponent.face_toward(player.global_position.x)
	_handle_hazard(delta)
	_check_ko()

func _handle_player(delta: float) -> void:
	var mx := stick_x
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		mx -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		mx += 1.0
	mx = clamp(mx, -1.0, 1.0)
	_move(player, mx, delta)
	if pending != "":
		_do_attack(player, opponent, pending)
		pending = ""

func _handle_ai(delta: float) -> void:
	var dx: float = player.global_position.x - opponent.global_position.x
	var dist: float = abs(dx)
	var dir := 0.0
	if dist > ATTACK_RANGE * 0.9:
		dir = signf(dx)
	_move(opponent, dir, delta)

	ai_cd -= delta
	if ai_cd > 0.0:
		return
	ai_cd = AI_REACTION.get(MatchConfig.difficulty, 0.55)
	if dist <= ATTACK_RANGE:
		if opponent.hype >= 100.0 and opponent.can_attack(40.0):
			_do_attack(opponent, player, "special")
		else:
			var roll := randf()
			var mv := "punch" if roll < 0.5 else ("kick" if roll < 0.8 else "grab")
			_do_attack(opponent, player, mv)

func _move(f: Node3D, dir: float, delta: float) -> void:
	if f.downed or dir == 0.0:
		return
	var speed: float = 1.6 + float(f.data["speed"]) * 0.45
	f.position.x = clamp(f.position.x + dir * speed * delta, -RING_HALF, RING_HALF)

func _do_attack(attacker: Node3D, defender: Node3D, move_id: String) -> void:
	var move: Dictionary = GameData.MOVES[move_id]
	if not attacker.can_attack(float(move["stamina_cost"])):
		return
	attacker.on_attack(move)
	attacker.face_toward(defender.global_position.x)
	var dist: float = abs(attacker.global_position.x - defender.global_position.x)
	if dist <= ATTACK_RANGE and not defender.downed:
		var res: Dictionary = GameData.resolve_move(int(attacker.data["strength"]), move_id, false)
		defender.take_hit(float(res["damage"]), attacker.global_position.x)
		var push: float = signf(defender.global_position.x - attacker.global_position.x)
		defender.position.x = clamp(defender.position.x + push * float(res["knockback"]) * 0.12, -RING_HALF, RING_HALF)
		_spark((attacker.global_position + defender.global_position) * 0.5 + Vector3(0, 1.2, 0))
		_shake()
		if audio:
			audio.hit_sfx()
		if attacker == player and move_id == "punch":
			PlayerProfile.record_punch()

func _handle_hazard(delta: float) -> void:
	var hz: Dictionary = MatchConfig.arena()
	hazard_ms += delta * 1000.0
	if hazard_ms >= float(hz["hazard_ms"]):
		hazard_ms = 0.0
		_spawn_hazard(float(hz["hazard_damage"]))

func _spawn_hazard(dmg: float) -> void:
	var box := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = Vector3(0.8, 0.8, 0.8)
	box.mesh = bm
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("d0a020")
	box.material_override = mat
	box.position = Vector3(randf_range(-1.0, 1.0), 8.0, 0)
	add_child(box)
	var t := create_tween()
	t.tween_property(box, "position:y", 0.5, 0.5)
	t.tween_callback(func():
		for f in [player, opponent]:
			if abs(f.global_position.x - box.global_position.x) < HAZARD_HALF and not f.downed:
				f.take_hit(dmg, box.global_position.x)
		_shake()
	)
	t.tween_interval(0.4)
	t.tween_callback(box.queue_free)

func _spark(pos: Vector3) -> void:
	var s := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 0.25
	sm.height = 0.5
	s.mesh = sm
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color.WHITE
	mat.emission_enabled = true
	mat.emission = Color.WHITE
	s.material_override = mat
	s.position = pos
	add_child(s)
	var t := create_tween()
	t.tween_property(s, "scale", Vector3(2, 2, 2), 0.15)
	t.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.15)
	t.tween_callback(s.queue_free)

func _shake(amount := 0.12) -> void:
	var t := create_tween()
	var base := Vector3(0, 3.2, 9.6)
	t.tween_property(camera, "position", base + Vector3(randf_range(-amount, amount), randf_range(-amount, amount), 0), 0.04)
	t.tween_property(camera, "position", base, 0.08)

# ---------------------------------------------------------------- resolve

func _update_hud() -> void:
	p_bars["health"].value = player.health / player.max_health * 100.0
	p_bars["stamina"].value = player.stamina
	p_bars["hype"].value = player.hype
	o_bars["health"].value = opponent.health / opponent.max_health * 100.0
	o_bars["stamina"].value = opponent.stamina
	o_bars["hype"].value = opponent.hype
	# Two-stage KO cue: someone near death.
	finish_hint.visible = state == "active" and (player.health <= player.max_health * 0.18 or opponent.health <= opponent.max_health * 0.18)

func _check_ko() -> void:
	if opponent.health <= 0.0:
		_end(0)
	elif player.health <= 0.0:
		_end(1)

func _end(winner: int) -> void:
	if state != "active":
		return
	state = "ended"
	finish_hint.visible = false
	var w: Node3D = player if winner == 0 else opponent
	var l: Node3D = opponent if winner == 0 else player
	l.flop()
	if audio:
		audio.ko_sfx()
	MatchConfig.last_winner = winner
	# Two-stage: a full-Hype winner earns the character finisher; else plain KO.
	if w.hype >= 100.0:
		MatchConfig.last_finisher_used = true
		# Bring fighters center-frame for the cinematic.
		w.position.x = -0.85
		l.position.x = 0.7
		var fin: Dictionary = GameData.FINISHERS[w.data["finisher"]]
		_banner(String(fin["label"]) + "!", UI.ACCENT)
		_camera_punch_in()
		await get_tree().create_timer(float(fin["duration_ms"]) / 1000.0).timeout
	else:
		MatchConfig.last_finisher_used = false
		_banner("K.O.", UI.HEALTH)
		await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://scenes/Results.tscn")

func _banner(text: String, color: Color) -> void:
	banner.text = text
	banner.add_theme_color_override("font_color", color)
	banner.visible = true

func _camera_punch_in() -> void:
	var from: Vector3 = camera.position
	var to := Vector3(0, 2.4, 7.9)
	var t := create_tween()
	t.tween_method(func(p: float):
		camera.position = from.lerp(to, p)
		camera.look_at(Vector3(0, 1.1, 0), Vector3.UP), 0.0, 1.0, 0.3)
	t.parallel().tween_property(camera, "fov", 42.0, 0.3)

# ---------------------------------------------------------------- debug/verify

func _apply_debug() -> void:
	match Shot.debug_arg:
		"mid":
			player.position.x = -1.2
			opponent.position.x = 1.2
			player.health = player.max_health * 0.55
			opponent.health = opponent.max_health * 0.35
			player.hype = 80.0
			opponent.hype = 45.0
			player.stamina = 70.0
		"ko":
			opponent.health = 3.0
			player.hype = 10.0
			_end(0)
		"finish":
			opponent.health = 3.0
			player.hype = 100.0
			_end(0)
