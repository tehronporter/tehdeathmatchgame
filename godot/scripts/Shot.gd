extends Node
## Autoload: verification helper. When the game is launched with
##   -- --screenshot <path> [--goto <res://scene.tscn>] [--debug <arg>]
## it optionally jumps to a scene, waits for it to render, saves a PNG, quits.
## Lets any screen be verified headlessly from the CLI (see verify.sh).

var debug_arg := ""

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var path := ""
	var goto := ""
	for i in args.size():
		if args[i] == "--screenshot" and i + 1 < args.size():
			path = args[i + 1]
		elif args[i] == "--goto" and i + 1 < args.size():
			goto = args[i + 1]
		elif args[i] == "--debug" and i + 1 < args.size():
			debug_arg = args[i + 1]
	if goto != "":
		call_deferred("_change", goto)
	if path != "":
		_capture(path)

func _change(scene: String) -> void:
	get_tree().change_scene_to_file(scene)

func _capture(path: String) -> void:
	await get_tree().process_frame
	await get_tree().create_timer(0.4).timeout
	for _n in 8:
		await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	img.save_png(path)
	get_tree().quit()
