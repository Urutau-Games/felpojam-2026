extends Button

@export var action_button_delay: float = 0.5

func _pressed() -> void:
	await _action_timer().timeout
	SceneManager.transition_to(SceneManager.Scene.TITLE)

func _action_timer() -> SceneTreeTimer:
	return get_tree().create_timer(action_button_delay)
