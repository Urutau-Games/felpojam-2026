extends Control

@onready var dungeon_map: GridContainer = %DungeonMap
@onready var command_panel: PanelContainer = $MarginContainer/Control/HBoxContainer/Panel/VBoxContainer/CommandPanel

@onready var constructs_sent_label: Label = %ConstructsSentLabel
@onready var remaining_totems: Label = %RemainingTotems

func _on_clean_button_pressed() -> void:
	command_panel.clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_stamp"):
		GameManager.drop_stamp()

func _on_send_button_pressed() -> void:
	command_panel.send()

# TODO: Move to an observable approach
func _process(_delta: float) -> void:
	constructs_sent_label.text = str(GameManager.used_constructs)
	remaining_totems.text = str(GameManager.totems_remaining)
