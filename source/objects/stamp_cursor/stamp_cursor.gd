extends Sprite2D
class_name StampCursor

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed(&"place_command"):
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.1)
		tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.05)
		tween.tween_interval(0.1)
		tween.tween_property(self, "scale", Vector2.ONE, 0.05)
