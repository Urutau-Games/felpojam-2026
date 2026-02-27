@tool
extends Control

@export var auto_start: bool = false

@export_tool_button("Preview") var preview_action: Callable = start
@export_tool_button("Reset") var reset_action: Callable = reset.bind(1)

var _containers: Array[CreditsContainer] = []

func _ready() -> void:
	reset()

	if auto_start:
		start()

func start() -> void:
	for container in _containers:
		container.visible = true
		await _show(container).finished
		container.visible = false

func reset(modulate_value: float = 0) -> void:
	for child in get_children():
		child.visible = false
		child.modulate = Color(Color.WHITE, modulate_value)
		if child is CreditsContainer:
			_containers.push_back(child)

func _show(container: CreditsContainer) -> Tween:
	var tween = create_tween()
	tween.tween_property(container, 'modulate:a', 1, container.show_time)
	tween.tween_interval(container.view_time)
	tween.tween_property(container, 'modulate:a', 0, container.hide_time)
	return tween


func _on_back_pressed() -> void:
	pass # Replace with function body.
