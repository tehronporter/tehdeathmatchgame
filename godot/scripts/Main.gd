extends Node3D
## G0 smoke test: prove a lit 3D scene renders (what expo-gl failed to do on the
## iOS Simulator). Builds a side-on 2.5D ring view with two primitive fighters,
## then optionally screenshots and quits when run with `-- --screenshot <path>`.

func _ready() -> void:
	_build_scene()
	_maybe_screenshot()

func _build_scene() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("3a1e1e") # Wrestling Ring arena tint
	env.ambient_light_color = Color.WHITE
	env.ambient_light_energy = 0.45
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)

	var cam := Camera3D.new()
	cam.position = Vector3(0.0, 3.0, 9.0)
	cam.fov = 50.0
	add_child(cam)
	cam.look_at(Vector3(0.0, 1.0, 0.0), Vector3.UP)

	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-50.0, -35.0, 0.0)
	light.light_energy = 1.3
	add_child(light)

	var ground := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(14.0, 14.0)
	ground.mesh = pm
	var gmat := StandardMaterial3D.new()
	gmat.albedo_color = Color(0.04, 0.04, 0.04)
	ground.material_override = gmat
	add_child(ground)

	add_child(_make_fighter(Color("1e6bff"), -1.5)) # The Action Hero
	add_child(_make_fighter(Color("ff2b4d"), 1.5))  # The Wrestler

func _make_fighter(col: Color, x: float) -> Node3D:
	var root := Node3D.new()
	root.position = Vector3(x, 0.0, 0.0)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = col

	var torso := MeshInstance3D.new()
	var bm := BoxMesh.new()
	bm.size = Vector3(0.8, 1.2, 0.6)
	torso.mesh = bm
	torso.material_override = mat
	torso.position = Vector3(0.0, 1.0, 0.0)
	root.add_child(torso)

	# Oversized head per the PRD's exaggerated proportions.
	var head := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 0.34
	sm.height = 0.68
	head.mesh = sm
	head.material_override = mat
	head.position = Vector3(0.0, 2.0, 0.0)
	root.add_child(head)
	return root

func _maybe_screenshot() -> void:
	var args := OS.get_cmdline_user_args()
	var path := ""
	for i in args.size():
		if args[i] == "--screenshot" and i + 1 < args.size():
			path = args[i + 1]
	if path == "":
		return
	for _n in 6:
		await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(path)
	get_tree().quit()
