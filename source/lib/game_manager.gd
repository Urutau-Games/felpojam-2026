extends Node

signal position_revealed(position: Vector2i, room: StringName)

signal command_started(command_index: int)
signal command_finished(command_index: int)
signal command_failed(command_index: int)

signal construct_moved(from: Vector2i, to: Vector2i)
signal dungeon_changed(position: Vector2i, new_value: StringName)

signal scan_completed(items: Dictionary[StringName, int])

signal target_reached()

var active_stamp: StampData
var current_room: Vector2i
var starting_room: Vector2i
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

var current_room_content: StringName:
	get:
		return dungeon[current_room.x][current_room.y]
	set(value):
		dungeon[current_room.x][current_room.y] = value
		dungeon_changed.emit(current_room, value)

func _ready() -> void:
	command_failed.connect(_on_command_failed)
	
	var file := FileAccess.open("res://data/dungeons/dungeon_1.txt", FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var line := file.get_line()
		
		if not starting_room:
			var entrance := line.find(Constants.ENTRANCE_CHAR)
		
			if entrance > -1:
				starting_room = Vector2i(dungeon.size(), entrance)
				current_room = starting_room
		
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
	Input.set_custom_mouse_cursor(stamp.stamp_cursor, Input.CURSOR_ARROW, hotspot)
	active_stamp = stamp

func execute(commands: Array[String]) -> void:
	used_constructs += 1
	var previous_position := current_room
	var command_index = 0
	
	for command in commands:
		command_started.emit(command_index)
		
		if not _command_map[command].call():
			command_failed.emit(command_index)
			break
		
		if(not current_room == previous_position):
			construct_moved.emit(previous_position, current_room)
			previous_position = current_room
		
		if not revealed_positions.has(current_room):
			_reveal_current_room()

		if _is_hazard():
			command_failed.emit(command_index)
			break
		elif _is_target():
			command_finished.emit(command_index)
			target_reached.emit()
			break
		else:
			await get_tree().create_timer(0.5).timeout
		
			command_finished.emit(command_index)
			command_index += 1
			
	if command_index == commands.size():
		current_room = starting_room

func _on_command_failed(_command_index: int) -> void:
	current_room = starting_room

func _reveal_current_room():
	revealed_positions.push_back(current_room)
	position_revealed.emit(current_room, current_room_content)

func _is_hazard() -> bool:
	return Constants.ROOM_HAZARDS.has(current_room_content)

func _is_target() -> bool:
	return current_room_content == Constants.ROOM_DESTINATION

func _is_in_boundaries(room: Vector2i):
	return Constants.DUNGEON_BOUNDARIES.has_point(room)

func _room_value(room: Vector2i) -> StringName:
	return dungeon[room.x][room.y]

func _has_monster() -> bool:
	return current_room_content == Constants.ROOM_MONSTER

func _can_move_to(room: Vector2i) -> bool:
	return _is_in_boundaries(room) and not _has_monster()

func _execute_move(room: Vector2i) -> bool:
	if not _can_move_to(room):
		return false
	
	current_room = room
	
	return true

#region Commands
func _east() -> bool:
	return _execute_move(current_room + Constants.EAST_MOVEMENT)

func _west() -> bool:
	return _execute_move(current_room + Constants.WEST_MOVEMENT)

func _north() -> bool:
	return _execute_move(current_room + Constants.NORTH_MOVEMENT)

func _south() -> bool:
	return _execute_move(current_room + Constants.SOUTH_MOVEMENT)

func _disarm() -> bool:
	if _has_monster():
		return false
		
	for possible_move in Constants.ADJACENT_ROOMS:
		var next_room := current_room + possible_move
		
		if _is_in_boundaries(next_room) and _room_value(next_room) == Constants.ROOM_TRAP:
			dungeon[next_room.x][next_room.y] = Constants.ROOM_EMPTY
			dungeon_changed.emit(next_room, Constants.ROOM_EMPTY)
		
	return true
	
func _scan() -> bool:
	if _has_monster():
		return false
		
	var found_items: Dictionary[StringName, int] = {}
	
	for possible_move in Constants.ADJACENT_ROOMS:
		var next_room := current_room + possible_move
		
		if _is_in_boundaries(next_room):
			var room_value := _room_value(next_room)
			if Constants.SCANNEABLE_ITEMS.has(room_value):
				if room_value in found_items.keys(): 
					found_items[room_value] += 1
				else: 
					found_items[room_value] = 1

	scan_completed.emit(found_items)
	return true
	
func _totem() -> bool:
	if totems_remaining == 0 or not current_room_content == Constants.ROOM_EMPTY:
		return false
	
	starting_room = current_room
	totems_remaining -= 1
	current_room_content = Constants.ROOM_TOTEM
	
	return true
	
func _attack() -> bool:
	if _has_monster():
		current_room_content = Constants.ROOM_EMPTY
	
	return true
#endregion
