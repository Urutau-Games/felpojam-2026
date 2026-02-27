extends Control
class_name CommandPanel

@onready var command_grid: GridContainer = %CommandGrid
@onready var place_totem_button: TextureButton = %PlaceTotemButton

var _used_slots: int = 0
var _commands: Array[String] = []

const GAMEPLAY_HEIGHT: float = 724
const INSERT_HEIGHT: float = 850

var remaining_slots: int:
	get:
		return Constants.MAX_COMMANDS - _used_slots

func _ready() -> void:
	GameManager.command_started.connect(_modulate_command.bind(Color.LAWN_GREEN))
	GameManager.command_failed.connect(_modulate_command.bind(Color.INDIAN_RED))
	GameManager.command_finished.connect(_modulate_command.bind(Color.WHITE))
	
	GameManager.execution_finished.connect(_on_execution_finished)

func _gui_input(event: InputEvent) -> void:
	if not event is InputEventMouse:
		return
		
	if event.is_action_released("place_command"):
		_place_command(GameManager.active_stamp)

func _place_command(stamp_data: StampData) -> void:
	if _has_space(stamp_data):
		var tile = TextureRect.new()
		tile.texture = stamp_data.stamp_texture
		tile.modulate = Color(Color.WHITE, stamp_data.charge)
		command_grid.add_child(tile)
		
		stamp_data.use()
		
		_used_slots += stamp_data.command_size
		
		_commands.push_back(stamp_data.command)
		
	if not _has_space(stamp_data):
		GameManager.release_stamp()

func _has_space(stamp_data: StampData) -> bool:
	return stamp_data and stamp_data.command_size <= remaining_slots

func clear() -> void:
	_commands = []
	_used_slots = 0

	for c in command_grid.get_children():
		c.queue_free()

func send() -> void:
	_insert().tween_callback(GameManager.execute.bind(_commands))

func is_empty() -> bool:
	return remaining_slots == Constants.MAX_COMMANDS

func _insert() -> Tween:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'position:y', INSERT_HEIGHT, 0.2)
	return tween

func _eject() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, 'position:y', GAMEPLAY_HEIGHT, 0.2)

func _on_execution_finished() -> void:
	_eject()

func _modulate_command(command_index: int, color: Color) -> void:
	var tile = command_grid.get_child(command_index) as TextureRect
	tile.modulate = color

#TODO: Move some logic to observable
func _process(_delta: float) -> void:
	place_totem_button.disabled = GameManager.totems_remaining <= 0
