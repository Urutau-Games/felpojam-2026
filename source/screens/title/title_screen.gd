extends Control

@export var action_button_delay: float = 0.5

@onready var extras: Button = $Others/Extras

func _ready() -> void:
	extras.visible = ExtrasManager.has_any()

func _on_play_pressed() -> void:
	await _action_timer().timeout
	SceneManager.transition_to(SceneManager.Scene.PLAY)


func _on_exit_pressed() -> void:
	await _action_timer().timeout
	get_tree().quit()


func _on_credits_pressed() -> void:
	await _action_timer().timeout
	SceneManager.transition_to(SceneManager.Scene.CREDITS)


func _on_options_pressed() -> void:
	await _action_timer().timeout
	SceneManager.transition_to(SceneManager.Scene.OPTIONS)


func _on_extras_pressed() -> void:
	await _action_timer().timeout
	SceneManager.transition_to(SceneManager.Scene.EXTRA)

func _action_timer() -> SceneTreeTimer:
	return get_tree().create_timer(action_button_delay)
