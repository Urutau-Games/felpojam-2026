extends Control

@onready var dungeon_map: GridContainer = %DungeonMap
@onready var command_panel: PanelContainer = $MarginContainer/Control/HBoxContainer/Panel/VBoxContainer/CommandPanel

func _on_clean_button_pressed() -> void:
	command_panel.clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_stamp"):
		GameManager.drop_stamp()

func _on_send_button_pressed() -> void:
	command_panel.send()
