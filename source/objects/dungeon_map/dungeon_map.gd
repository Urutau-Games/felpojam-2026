extends GridContainer

@export var map_tile_scene: PackedScene

const AUTO_REVEALED_ROOMS: Array[StringName] = [Constants.ROOM_ENTRANCE, Constants.ROOM_DESTINATION]

func _ready() -> void:
	GameManager.position_revealed.connect(_on_position_revealed)
	GameManager.dungeon_changed.connect(_on_dungeon_changed)
	GameManager.construct_moved.connect(_on_construct_moved)
	
	_clean_placeholders()
	_initialize_map()

func _clean_placeholders() -> void:
	for placeholder in get_children():
		placeholder.queue_free()

func _initialize_map() -> void:
	for row in Constants.DUNGEON_HEIGHT:
		for col in Constants.DUNGEON_WIDTH:
			var tile: MapTile = map_tile_scene.instantiate()
			add_child(tile)
			
			var room_value = GameManager.dungeon[row][col]
			
			if AUTO_REVEALED_ROOMS.has(room_value):
				tile.set_special_tile(room_value)

func _to_index(dungeon_position: Vector2i) -> int:
	return Constants.DUNGEON_WIDTH * dungeon_position.x + dungeon_position.y

func _on_position_revealed(dungeon_position: Vector2i, room: StringName) -> void:
	_get_tile_at(dungeon_position).reveal(room)

func _on_construct_moved(_from: Vector2i, to: Vector2i) -> void:
	var tile := _get_tile_at(to)
	
	var tween := get_tree().create_tween()
	tween.tween_property(tile, 'modulate', Color.GREEN_YELLOW, 0.01)
	tween.tween_property(tile, 'modulate', Color.WHITE, 0.25)

func _on_dungeon_changed(room_position: Vector2i, new_value: StringName) -> void:
	if GameManager.starting_room == room_position:
		_get_tile_at(room_position).set_special_tile(new_value)
	elif GameManager.revealed_positions.has(room_position):
		_get_tile_at(room_position).reveal(new_value)

func _get_tile_at(room_position: Vector2i) -> MapTile:
	return get_child(_to_index(room_position)) as MapTile
