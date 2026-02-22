extends Control

@onready var command_grid: GridContainer = %CommandGrid

var _used_slots: int = 0
var _commands: Array[String] = []

var remaining_slots: int:
	get:
		return Constants.MAX_COMMANDS - _used_slots

func _ready() -> void:
	GameManager.command_started.connect(_modulate_command.bind(Color.LAWN_GREEN))
	GameManager.command_failed.connect(_modulate_command.bind(Color.INDIAN_RED))
	GameManager.command_finished.connect(_modulate_command.bind(Color.WHITE))

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouse:
		return
		
	if event.is_action_released("place_command"):
		_place_command(GameManager.active_stamp)

func _place_command(stamp_data: StampData) -> void:
	if _has_space(stamp_data):
		var tile = TextureRect.new()
		tile.texture = stamp_data.stamp_texture
		command_grid.add_child(tile)
		_used_slots += stamp_data.command_size
		_commands.push_back(stamp_data.command)
		
	if not _has_space(stamp_data):
		GameManager.drop_stamp()

func _has_space(stamp_data: StampData) -> bool:
	return stamp_data and stamp_data.command_size <= remaining_slots

func clear() -> void:
	_commands = []
	_used_slots = 0

	for c in command_grid.get_children():
		c.queue_free()

func send() -> void:
	GameManager.execute(_commands)

func _modulate_command(command_index: int, color: Color) -> void:
	var tile = command_grid.get_child(command_index) as TextureRect
	tile.modulate = color
