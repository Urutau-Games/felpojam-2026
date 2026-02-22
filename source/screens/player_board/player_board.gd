extends Control

var _dungeon: Array[Array] = []

var unknwon_tile: Texture2D = preload("res://assets/placeholders/unknown.png")

var tile_code : Dictionary[String, Texture2D] = {
	"E": preload("res://assets/placeholders/entrance.png"),
	"D": preload("res://assets/placeholders/destination.png"),
	"1": preload("res://assets/placeholders/empty.png"),
	"2": preload("res://assets/placeholders/chest.png"),
	"4": preload("res://assets/placeholders/hole.png"),
	"5": preload("res://assets/placeholders/monster.png"),
	"6": preload("res://assets/placeholders/trap.png")
}

@onready var dungeon_map: GridContainer = %DungeonMap
@onready var command_panel: GridContainer = %CommandPanel

const MAX_COMMANDS: int = 10

func _ready() -> void:
	var file := FileAccess.open("res://data/dungeons/dungeon_1.txt", FileAccess.READ)
	
	while file.get_position() < file.get_length():
		var line := file.get_line()
		_dungeon.push_back(line.split())

	for row in _dungeon.size():
		for col in _dungeon[row].size():
			var child_index = row * dungeon_map.columns + col
			var tile = dungeon_map.get_child(child_index)
			var room_value = _dungeon[row][col]
			match room_value:
				"E":
					tile.texture = tile_code["E"]
				"D":
					tile.texture = tile_code["D"]
				_:
					tile.texture = unknwon_tile
