extends GridContainer

var _unknwon_tile: Texture2D = preload("res://assets/placeholders/unknown.png")

var tile_code : Dictionary[String, Texture2D] = {
	Constants.ROOM_ENTRANCE: preload("res://assets/placeholders/entrance.png"),
	Constants.ROOM_DESTINATION: preload("res://assets/placeholders/destination.png"),
	Constants.ROOM_EMPTY: preload("res://assets/placeholders/empty.png"),
	Constants.ROOM_CHEST: preload("res://assets/placeholders/chest.png"),
	Constants.ROOM_HOLE: preload("res://assets/placeholders/hole.png"),
	Constants.ROOM_MONSTER: preload("res://assets/placeholders/monster.png"),
	Constants.ROOM_TRAP: preload("res://assets/placeholders/trap.png"),
	Constants.ROOM_TOTEM: preload("res://assets/placeholders/place_totem.png")
}

const AUTO_REVEALED_ROOMS: Array[StringName] = [Constants.ROOM_ENTRANCE, Constants.ROOM_DESTINATION]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.position_revealed.connect(_on_position_revealed)
	GameManager.dungeon_changed.connect(_on_dungeon_changed)
	GameManager.construct_moved.connect(_on_construct_moved)
	
	for row in Constants.DUNGEON_HEIGHT:
		for col in Constants.DUNGEON_WIDTH:
			var child_index = _to_index(Vector2i(row, col))
			
			var room_value = GameManager.dungeon[row][col]
			
			if AUTO_REVEALED_ROOMS.has(room_value):
				_set_tile_texture(child_index, tile_code[room_value])
			else:
				_set_tile_texture(child_index)

func _to_index(dungeon_position: Vector2i) -> int:
	return Constants.DUNGEON_WIDTH * dungeon_position.x + dungeon_position.y

func _set_tile_texture(index: int, texture: Texture2D = _unknwon_tile) -> void:
	var tile = get_child(index) as TextureRect
	tile.texture = texture

func _on_position_revealed(dungeon_position: Vector2i, room: StringName) -> void:
	_set_tile_texture(_to_index(dungeon_position), tile_code[room])

func _on_construct_moved(_from: Vector2i, to: Vector2i) -> void:
	var tile = get_child(_to_index(to)) as TextureRect
	
	var tween := get_tree().create_tween()
	tween.tween_property(tile, 'modulate', Color.GREEN_YELLOW, 0.01)
	tween.tween_property(tile, 'modulate', Color.WHITE, 0.25)


func _on_dungeon_changed(room_position: Vector2i, new_value: StringName) -> void:
	if GameManager.revealed_positions.has(room_position):
		var tile = get_child(_to_index(room_position))
		tile.texture = tile_code[new_value]
