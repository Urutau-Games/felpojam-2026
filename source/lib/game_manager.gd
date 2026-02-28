extends Node
class_name GameManagerService

@warning_ignore("unused_signal")
signal position_revealed(position: Vector2i, room: StringName)

signal command_started(command_index: int)
signal command_finished(command_index: int)
signal command_failed(command_index: int)

signal construct_moved(from: Vector2i, to: Vector2i)

@warning_ignore("unused_signal")
signal dungeon_changed(position: Vector2i, new_value: StringName)

@warning_ignore("unused_signal")
signal dungeon_started()

signal scan_completed(items: Array[ScanResult])

signal target_reached()

signal execution_started()
signal execution_finished()

signal stamp_picked(stamp: StampData)
signal stamp_dropped(is_release: bool)

var dungeon_data_path: Array[String] = [
	"res://data/dungeons/dungeon_1.txt",
	"res://data/dungeons/dungeon_2.txt",
	"res://data/dungeons/dungeon_3.txt"
]

var active_stamp: StampData
var run: GameRun

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

var loaded_dungeons: Array[Dungeon]

func _ready() -> void:
	command_failed.connect(_on_command_failed)
	
	for data_path in dungeon_data_path:
		var dungeon = Dungeon.new(data_path)
		loaded_dungeons.push_back(dungeon)

func release_stamp() -> void:
	active_stamp = null
	stamp_dropped.emit(true)

func drop_stamp() -> void:
	active_stamp = null
	stamp_dropped.emit(false)

func hold_stamp(stamp: StampData) -> void:
	active_stamp = stamp
	stamp_picked.emit(stamp)

func execute(commands: Array[String]) -> void:
	run.used_constructs += 1
	var previous_position := run.current_room
	var command_index = 0
	
	execution_started.emit()
	
	for command in commands:
		command_started.emit(command_index)
		
		if not _command_map[command].call():
			command_failed.emit(command_index)
			break
		
		if(not run.current_room == previous_position):
			construct_moved.emit(previous_position, run.current_room)
			previous_position = run.current_room
		
		if not run.is_revealed():
			run.reveal_current_room()

		if run.is_hazard():
			command_failed.emit(command_index)
			break
		elif run.is_target():
			command_finished.emit(command_index)
			target_reached.emit()
			break
		else:
			if run.is_chest():
				ExtrasManager.extra_found.emit(run.current_room_content)
				await get_tree().create_timer(0.5).timeout
				run.make_current_room_empty()
			
			await get_tree().create_timer(0.5).timeout
		
			command_finished.emit(command_index)
			command_index += 1

	execution_finished.emit()

	if command_index == commands.size():
		run.back_to_start()

func new_run() -> void:
	run = GameRun.new(loaded_dungeons, self)

func _on_command_failed(_command_index: int) -> void:
	run.back_to_start()

#region Commands
func _east() -> bool:
	return run.execute_move(Constants.EAST_MOVEMENT)

func _west() -> bool:
	return run.execute_move(Constants.WEST_MOVEMENT)

func _north() -> bool:
	return run.execute_move(Constants.NORTH_MOVEMENT)

func _south() -> bool:
	return run.execute_move(Constants.SOUTH_MOVEMENT)

func _disarm() -> bool:
	if run.has_monster():
		return false
		
	for possible_move in Constants.ADJACENT_ROOMS:
		run.check_and_disarm(possible_move)
		
	return true
	
func _scan() -> bool:
	if run.has_monster():
		return false
		
	var found_items: Array[ScanResult] = []
	
	for possible_move in Constants.ADJACENT_ROOMS:
		var result := run.scan(possible_move)
		
		if result:
			found_items.push_back(result)
			
	scan_completed.emit(found_items)
	
	return true
	
func _totem() -> bool:
	return run.place_totem()
	
func _attack() -> bool:
	if run.has_monster():
		run.make_current_room_empty()
	
	return true
#endregion

class ScanResult:
	var item: StringName
	var room: Vector2i

	func _init(new_item: StringName, new_room: Vector2i) -> void:
		item = new_item
		room = new_room

class Dungeon:
	var starting_room: Vector2i
	var target_position: Vector2i
	
	var rooms: Array[Array]
	
	func _init(path: String) -> void:
		rooms = []
		
		var file := FileAccess.open(path, FileAccess.READ)
	
		while file.get_position() < file.get_length():
			var line := file.get_line()
			
			if not starting_room:
				var entrance := line.find(Constants.ENTRANCE_CHAR)
			
				if entrance > -1:
					starting_room = Vector2i(rooms.size(), entrance)
			
			if not target_position:
				var destination := line.find(Constants.DESTINATION_CHAR)
				if destination > -1:
					target_position = Vector2i(rooms.size(), destination)
			
			for extra in Constants.ROOM_CHEST:
				if ExtrasManager.has(extra):
					line = line.replace(extra, Constants.ROOM_EMPTY)
			
			rooms.push_back(line.split())
	
	func is_in_boundaries(room: Vector2i):
		return Constants.DUNGEON_BOUNDARIES.has_point(room)
		
	func room_value(room: Vector2i) -> StringName:
		return rooms[room.x][room.y]

class GameRun:
	var game_manager: GameManagerService
	
	var current_dungeon: int
	var used_constructs: int
	var remaining_totems: int
	var revealed_positions: Array[Vector2i] = []
	
	var current_room: Vector2i
	var starting_room: Vector2i
	var target_position: Vector2i
	
	var dungeons: Array[Dungeon]
	
	var dungeon: Dungeon
	
	var current_room_content: StringName:
		get:
			return dungeon.rooms[current_room.x][current_room.y]
		set(value):
			dungeon.rooms[current_room.x][current_room.y] = value
			game_manager.dungeon_changed.emit(current_room, value)
	
	func _init(new_dungeons: Array[Dungeon], manager: GameManagerService):
		game_manager = manager
		dungeons = new_dungeons
		
		current_dungeon = 0
		used_constructs = 0

	func start_current_dungeon() -> void:
		_start_dungeon(current_dungeon)

	func reveal_current_room() -> void:
		revealed_positions.push_back(current_room)
		game_manager.position_revealed.emit(current_room, current_room_content)

	func is_current_room_revealed() -> void:
		return is_revealed(current_room)

	func is_revealed(room: Vector2i = current_room) -> bool:
		return revealed_positions.has(room)

	func is_hazard() -> bool:
		return Constants.ROOM_HAZARDS.has(current_room_content)

	func is_target() -> bool:
		return current_room_content == Constants.ROOM_DESTINATION

	func is_chest() -> bool:
		return Constants.ROOM_CHEST.has(current_room_content)

	func has_monster() -> bool:
		return current_room_content == Constants.ROOM_MONSTER

	func make_current_room_empty() -> void:
		make_empty(current_room)

	func make_empty(room: Vector2i) -> void:
		dungeon.rooms[room.x][room.y] = Constants.ROOM_EMPTY
		game_manager.dungeon_changed.emit(room, Constants.ROOM_EMPTY)

	func execute_move(to: Vector2i) -> bool:
		var new_room = current_room + to
		if not _can_move_to(new_room):
			return false
		
		current_room = new_room
		
		return true

	func place_totem() -> bool:
		if remaining_totems == 0 or not current_room_content == Constants.ROOM_EMPTY:
			return false
	
		starting_room = current_room
		current_room_content = Constants.ROOM_TOTEM
		
		remaining_totems -= 1
		
		return true

	func back_to_start() -> void:
		current_room = starting_room

	func check_and_disarm(direction: Vector2i) -> void:
		var next_room := current_room + direction
		if dungeon.is_in_boundaries(next_room) and dungeon.room_value(next_room) == Constants.ROOM_TRAP:
			make_empty(next_room)

	func scan(direction: Vector2i) -> ScanResult:
		var next_room := current_room + direction
		
		if dungeon.is_in_boundaries(next_room):
			var room_value := dungeon.room_value(next_room)
			if Constants.SCANNEABLE_ITEMS.has(room_value):
				return ScanResult.new(room_value, next_room)
		
		return null

	func next_dungeon() -> void:
		current_dungeon += 1
		start_current_dungeon()

	func is_last_dungeon() -> bool:
		return current_dungeon + 1 == dungeons.size()

	func _start_dungeon(index: int) -> void:
		dungeon = dungeons[index]
		
		current_room = dungeon.starting_room
		starting_room = dungeon.starting_room
		target_position = dungeon.target_position
		remaining_totems = Constants.MAX_TOTEMS
		
		revealed_positions = []
		
		game_manager.dungeon_started.emit()

	func _can_move_to(room: Vector2i) -> bool:
		return dungeon.is_in_boundaries(room) and not has_monster()
