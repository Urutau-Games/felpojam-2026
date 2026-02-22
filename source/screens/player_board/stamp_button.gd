extends TextureButton

var _hotspot: Vector2

func _ready() -> void:
	_hotspot = texture_normal.get_size() / 2

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		Input.set_custom_mouse_cursor(texture_normal, Input.CURSOR_ARROW, _hotspot)
	else:
		Input.set_custom_mouse_cursor(null)
	
