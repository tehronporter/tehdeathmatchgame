extends Node
## Autoload: subtle global CRT scanline + vignette overlay (late-90s MTV look).

func _ready() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)
	var rect := ColorRect.new()
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var sh := Shader.new()
	sh.code = """
shader_type canvas_item;
void fragment() {
	float scan = sin(UV.y * 900.0) * 0.5 + 0.5;
	float darken = mix(0.0, 0.09, scan);
	vec2 d = UV - vec2(0.5);
	float vig = smoothstep(0.85, 0.45, length(d));
	COLOR = vec4(0.0, 0.0, 0.0, darken + (1.0 - vig) * 0.14);
}
"""
	var mat := ShaderMaterial.new()
	mat.shader = sh
	rect.material = mat
	layer.add_child(rect)
