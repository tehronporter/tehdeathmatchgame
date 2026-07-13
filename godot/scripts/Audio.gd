extends Node
## Autoload: simple SFX pool + looping crowd ambience (procedural WAVs).

var _hit := preload("res://assets/sfx/hit.wav")
var _ko := preload("res://assets/sfx/ko.wav")
var _ui := preload("res://assets/sfx/ui.wav")
var _crowd := preload("res://assets/sfx/crowd.wav")

var _pool: Array[AudioStreamPlayer] = []
var _next := 0
var _crowd_player: AudioStreamPlayer

func _ready() -> void:
	for i in 6:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_pool.append(p)
	_crowd.loop_mode = AudioStreamWAV.LOOP_FORWARD
	_crowd.loop_begin = 0
	_crowd_player = AudioStreamPlayer.new()
	_crowd_player.stream = _crowd
	_crowd_player.volume_db = -16.0
	add_child(_crowd_player)

func _play(stream: AudioStream, vol := 0.0, pitch := 1.0) -> void:
	var p := _pool[_next]
	_next = (_next + 1) % _pool.size()
	p.stream = stream
	p.volume_db = vol
	p.pitch_scale = pitch
	p.play()

func hit_sfx() -> void:
	_play(_hit, -5.0, randf_range(0.9, 1.15))

func ko_sfx() -> void:
	_play(_ko, -2.0)

func ui_sfx() -> void:
	_play(_ui, -10.0)

func start_crowd() -> void:
	if not _crowd_player.playing:
		_crowd_player.play()

func stop_crowd() -> void:
	_crowd_player.stop()
