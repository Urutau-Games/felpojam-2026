extends Control


func _on_play_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.PLAY)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.CREDITS)


func _on_options_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.OPTIONS)


func _on_extras_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.EXTRA)
