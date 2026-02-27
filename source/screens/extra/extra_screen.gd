extends Control


func _on_back_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.TITLE)
