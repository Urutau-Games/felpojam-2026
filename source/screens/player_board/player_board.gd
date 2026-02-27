extends Control

const CLICK_AMOUNT: int = 40
const CLICK_PULL_BACK: int = CLICK_AMOUNT - 5
const CLICK_LOCKED: int = 5

@export var stamp_button_group: ButtonGroup
@export var action_button_delay: float = 0.5

@export_group("SFX Streams")
@export var execute_locked: AudioStream
@export var execute_clicked: AudioStream
@export var cancel_clicked: AudioStream
@export var stamp_placed: AudioStream

@onready var dungeon_map: GridContainer = %DungeonMap
@onready var command_panel: CommandPanel = %CommandPanel

@onready var constructs_sent_label: Label = %ConstructsSentLabel
@onready var remaining_totems: Label = %RemainingTotems
@onready var congrats_layer: CanvasLayer = %Congrats
@onready var cursor_container: CanvasLayer = %CursorContainer
@onready var dungeon_label: Label = %DungeonLabel

@onready var clean_button: TextureButton = %CleanButton
@onready var send_button: TextureButton = %SendButton

@onready var clean_button_y: float = clean_button.position.y
@onready var send_button_y: float = send_button.position.y

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

func _ready() -> void:
	MusicPlayer.play_planning_phase()
	
	GameManager.target_reached.connect(_on_target_reached)
	GameManager.stamp_picked.connect(_on_stamp_picked)
	GameManager.stamp_dropped.connect(_on_stamp_dropped)
	
	GameManager.execution_started.connect(_on_execution_started)
	GameManager.execution_finished.connect(_on_execution_finished)
	
	GameManager.new_run()
	GameManager.run.start_current_dungeon()

func _on_clean_button_pressed() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(clean_button, 'position:y', clean_button_y + CLICK_PULL_BACK, 0.05)
	tween.tween_property(clean_button, 'position:y', clean_button_y, 0.05)
	
	_play_sfx(cancel_clicked)
	
	command_panel.clear()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_stamp"):
		GameManager.release_stamp()

func _on_send_button_pressed() -> void:
	if command_panel.is_empty():
		var tween := create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(send_button, 'position:y', send_button_y + CLICK_LOCKED, 0.05)
		tween.tween_property(send_button, 'position:y', send_button_y, 0.05)
		
		_play_sfx(execute_locked)
	else:
		var tween := create_tween().set_ease(Tween.EASE_IN)
		tween.tween_property(send_button, 'position:y', send_button_y + CLICK_AMOUNT, 0.05)
		tween.tween_property(send_button, 'position:y', send_button_y + CLICK_PULL_BACK, 0.05)
		tween.tween_callback(command_panel.send)
		
		_play_sfx(execute_clicked)
		
		send_button.disabled = true

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
	dungeon_label.text = str(GameManager.run.current_dungeon + 1)
	constructs_sent_label.text = str(GameManager.run.used_constructs)
	remaining_totems.text = str(GameManager.run.remaining_totems)

func _on_target_reached() -> void:
	congrats_layer.visible = true

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_execution_started() -> void:
	MusicPlayer.play_action()

func _on_execution_finished() -> void:
	var tween := create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(send_button, 'position:y', send_button_y, 0.05)
	send_button.disabled = false
	
	MusicPlayer.play_planning_phase()

func _on_restart_pressed() -> void:
	await _action_timer().timeout
	GameManager.run.start_current_dungeon()

func _action_timer() -> SceneTreeTimer:
	return get_tree().create_timer(action_button_delay)

func _play_sfx(stream: AudioStream) -> void:
	sfx_player.stream = stream
	sfx_player.play()

func _on_command_panel_command_placed() -> void:
	_play_sfx(stamp_placed)

func _on_control_mouse_entered() -> void:
	if GameManager.active_stamp:
		GameManager.release_stamp()
