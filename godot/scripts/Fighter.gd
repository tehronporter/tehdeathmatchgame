extends Node3D
## A fighter: visual rig (oversized head per PRD) + combat state. Kinematic
## movement; switches to a comedic "flop" on KO. Combat math lives in GameData.

var data: Dictionary
var is_player := false
var facing := 1.0
var max_health := 100.0
var health := 100.0
var stamina := 100.0
var hype := 0.0
var attack_cd := 0.0
var hit_flash := 0.0
var lean := 0.0
var downed := false

var _mat: StandardMaterial3D
var _base_color: Color
var _rig: Node3D

func setup(c: Dictionary, player: bool, face: float) -> void:
	data = c
	is_player = player
	facing = face
	_base_color = Color(c["color"])
	max_health = 70.0 + float(c["health"]) * 12.0
	health = max_health
	_build()

func _build() -> void:
	_mat = StandardMaterial3D.new()
	_mat.albedo_color = _base_color
	_rig = Node3D.new()
	add_child(_rig)
	_box(Vector3(0.8, 1.1, 0.5), Vector3(0, 1.0, 0))          # torso
	_sphere(0.38, Vector3(0, 1.95, 0))                          # oversized head
	_box(Vector3(0.22, 0.7, 0.22), Vector3(-0.52, 1.05, 0))    # arm L
	_box(Vector3(0.22, 0.7, 0.22), Vector3(0.52, 1.05, 0))     # arm R
	_box(Vector3(0.26, 0.8, 0.26), Vector3(-0.2, 0.4, 0))      # leg L
	_box(Vector3(0.26, 0.8, 0.26), Vector3(0.2, 0.4, 0))       # leg R

func _box(size: Vector3, pos: Vector3) -> void:
	var m := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = size
	m.mesh = bm
	m.material_override = _mat
	m.position = pos
	_rig.add_child(m)

func _sphere(r: float, pos: Vector3) -> void:
	var m := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = r
	sm.height = r * 2.0
	m.mesh = sm
	m.material_override = _mat
	m.position = pos
	_rig.add_child(m)

func tick(delta: float) -> void:
	if attack_cd > 0.0:
		attack_cd -= delta
	if hit_flash > 0.0:
		hit_flash = max(0.0, hit_flash - delta * 4.0)
		_mat.albedo_color = _base_color.lerp(Color.WHITE, hit_flash)
	if not downed:
		stamina = min(100.0, stamina + 18.0 * delta)
	# ease lean back to neutral
	lean = lerp(lean, 0.0, delta * 8.0)
	if _rig and not downed:
		_rig.rotation.x = lean

func face_toward(target_x: float) -> void:
	facing = 1.0 if target_x >= global_position.x else -1.0

func can_attack(cost: float) -> bool:
	return not downed and attack_cd <= 0.0 and stamina >= cost

func on_attack(move: Dictionary) -> void:
	stamina -= float(move["stamina_cost"])
	hype = min(100.0, hype + float(move["hype_gain"]))
	attack_cd = 0.45
	lean = -0.25 * facing # lunge forward

func take_hit(damage: float, from_x: float) -> void:
	health = max(0.0, health - damage)
	hit_flash = 1.0
	lean = 0.3 * (1.0 if global_position.x >= from_x else -1.0)

func flop() -> void:
	downed = true
	var t := create_tween().set_parallel(true)
	t.tween_property(_rig, "rotation:z", PI * 0.5 * facing, 0.5)
	t.tween_property(_rig, "position:y", -0.4, 0.5)
