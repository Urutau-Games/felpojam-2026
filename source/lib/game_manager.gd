extends Node

signal position_revealed(position: Vector2i, room: StringName)
signal command_started(command_index)
signal command_finished(command_index)
signal command_failed(command_index)

var active_stamp: StampData
var current_position: Vector2i
var initial_position: Vector2i
var target_position: Vector2i

var dungeon: Array[Array] = []
var revealed_positions: Array[Vector2i] = []

var max_totems: int = 3
var totems_remaining: int = 3
var used_constructs: int = 0

var _command_map: Dictionary[StringName, Callable] = {
	Constants.COMMAND_NORTH: _north,
	Constants.COMMAND_SOUTH: _south,
	Constants.COMMAND_EAST: _east,
	Constants.COMMAND_WEST: _west,
	Constants.COMMAND_ATTACK: _attack,
	Constants.COMMAND_DISARM: _disarm,
	Constants.COMMAND_SCAN: _scan,
	Constants.COMMAND_TOTEM: _totem
}

var current_room: StringName:
	get:
		return dungeon[current_position.x][current_position.y]

func _ready() -> void:
	var file := FileAccess.open("res://data/dungeons/dungeon_1.txt", FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var line := file.get_line()
		
		if not initial_position:
			var entrance := line.find(Constants.ENTRANCE_CHAR)
		
			if entrance > -1:
				initial_position = Vector2i(dungeon.size(), entrance)
				current_position = initial_position
		
		if not target_position:
			var destination := line.find(Constants.DESTINATION_CHAR)
			if destination > -1:
				target_position = Vector2i(dungeon.size(), destination)
			
		dungeon.push_back(line.split())

func drop_stamp() -> void:
	Input.set_custom_mouse_cursor(null)
	active_stamp = null
	get_tree().call_group(&"stamp_button", "set_pressed_no_signal", false)

func hold_stamp(stamp: StampData, hotspot: Vector2) -> void:
	Input.set_custom_mouse_cursor(stamp.stamp_texture, Input.CURSOR_ARROW, hotspot)
	active_stamp = stamp

func execute(commands: Array[String]) -> void:
	used_constructs += 1
	var completed := true
	var previous_position := current_position
	var command_index = 0
	
	for command in commands:
		command_started.emit(command_index)
		completed = _command_map[command].call()
		
		if not completed:
			command_failed.emit(command_index)
			break
		
		if(not current_position == previous_position):
			print("Moved from %s to %s" % [previous_position, current_position])
			previous_position = current_position
		
		if not revealed_positions.has(current_position):
			_reveal_current_position()

		await get_tree().create_timer(0.5).timeout
		command_finished.emit(command_index)
		command_index += 1
	
	#if not completed:
		#current_position = initial_position

func _reveal_current_position():
	position_revealed.emit(current_position, current_room)

func _is_in_boundaries(next_position: Vector2i):
	return Constants.DUNGEON_BOUNDARIES.has_point(next_position)

#region Commands
func _east() -> bool:
	var next_position = current_position + Constants.EAST_MOVEMENT
	
	if not _is_in_boundaries(next_position):
		return false
	
	current_position = next_position
	
	return true

func _west() -> bool:
	var next_position = current_position + Constants.WEST_MOVEMENT
	
	if not _is_in_boundaries(next_position):
		return false
	
	current_position = next_position
	
	return true

func _north() -> bool:
	var next_position = current_position + Constants.NORTH_MOVEMENT
	
	if not _is_in_boundaries(next_position):
		return false
	
	current_position = next_position
	
	return true

func _south() -> bool:
	var next_position = current_position + Constants.SOUTH_MOVEMENT
	
	if not _is_in_boundaries(next_position):
		return false
	
	current_position = next_position
	
	return true

func _disarm() -> bool:
	return true
	
func _scan() -> bool:
	return true
	
func _totem() -> bool:
	return true
	
func _attack() -> bool:
	return true
#endregion
