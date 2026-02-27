class_name ButtonAudioStreamPlayer 
extends AudioStreamPlayer

func _ready() -> void:
	var parent = get_parent()
	
	if parent and parent is Button:
		parent.button_down.connect(_on_pressed)
	
func _on_pressed() -> void:
	play()
