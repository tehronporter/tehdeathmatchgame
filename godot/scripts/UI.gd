extends RefCounted
## Preload this script into a `const UI` in consumers (avoids relying on global
## class_name registration, which a headless CLI run doesn't perform).
## Shared MTV-chrome UI helpers: black + chrome borders, electric-blue accent,
## thick letter-spaced type. Used by every menu/HUD screen so the app reads as
## one system (per GAME_DESIGN.md art direction).

const BG := Color("000000")
const PANEL := Color("0a0a0a")
const CHROME := Color("8a8f98")
const ACCENT := Color("1e6bff")
const TEXT := Color("ffffff")
const DIM := Color("8a8f98")
const HEALTH := Color("ff2b4d")
const STAMINA := Color("ffd21e")
const HYPE := Color("1e6bff")

static func panel_style(border := CHROME, bg := PANEL, width := 2) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 10
	s.content_margin_bottom = 10
	return s

static func title(text: String, size := 44) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", TEXT)
	l.add_theme_constant_override("outline_size", 0)
	return l

static func label(text: String, size := 16, color := TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	return l

static func button(text: String, enabled := true) -> Button:
	var b := Button.new()
	b.text = text
	b.disabled = not enabled
	b.custom_minimum_size = Vector2(0, 54)
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_color", TEXT)
	b.add_theme_color_override("font_disabled_color", DIM)
	b.add_theme_color_override("font_hover_color", ACCENT)
	b.add_theme_stylebox_override("normal", panel_style())
	b.add_theme_stylebox_override("hover", panel_style(ACCENT))
	b.add_theme_stylebox_override("pressed", panel_style(ACCENT, ACCENT.darkened(0.6)))
	b.add_theme_stylebox_override("disabled", panel_style(DIM.darkened(0.5)))
	b.add_theme_stylebox_override("focus", panel_style(ACCENT))
	if enabled:
		b.pressed.connect(func():
			var a := b.get_tree().root.get_node_or_null("Audio")
			if a:
				a.ui_sfx())
	return b

## Full-screen dark background for a menu root.
static func fill_bg(control: Control) -> void:
	var cr := ColorRect.new()
	cr.color = BG
	cr.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	cr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.add_child(cr)
