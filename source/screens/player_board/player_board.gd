extends Control

@onready var dungeon_map: GridContainer = %DungeonMap
@onready var command_panel: PanelContainer = %CommandPanel

@onready var constructs_sent_label: Label = %ConstructsSentLabel
@onready var remaining_totems: Label = %RemainingTotems
@onready var congrats_layer: CanvasLayer = %Congrats
@onready var cursor_container: CanvasLayer = %CursorContainer

@export var stamp_button_group: ButtonGroup

func _ready() -> void:
	MusicPlayer.play_planning_phase()
	
	GameManager.target_reached.connect(_on_target_reached)
	GameManager.stamp_picked.connect(_on_stamp_picked)
	GameManager.stamp_dropped.connect(_on_stamp_dropped)
	
	GameManager.execution_started.connect(_on_execution_started)
	GameManager.execution_finished.connect(_on_execution_finished)

func _on_clean_button_pressed() -> void:
	command_panel.clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_stamp"):
		GameManager.release_stamp()

func _on_send_button_pressed() -> void:
	command_panel.send()

func _on_stamp_picked(stamp: StampData) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	var cursor = StampCursor.new()
	cursor.texture = stamp.stamp_cursor
	cursor_container.add_child(cursor)

func _on_stamp_dropped(is_release = false) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for cursor in cursor_container.get_children():
		cursor.queue_free()
		
	if is_release:
		stamp_button_group.get_pressed_button().set_pressed_no_signal(false)

# TODO: Move to an observable approach
func _process(_delta: float) -> void:
	constructs_sent_label.text = str(GameManager.used_constructs)
	remaining_totems.text = str(GameManager.totems_remaining)

func _on_target_reached() -> void:
	congrats_layer.visible = true

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_execution_started() -> void:
	MusicPlayer.play_action()
	
func _on_execution_finished() -> void:
	MusicPlayer.play_planning_phase()
