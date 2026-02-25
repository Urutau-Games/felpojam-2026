extends Object
class_name Constants

const DUNGEON_WIDTH: int = 15
const DUNGEON_HEIGHT: int = 5

const ENTRANCE_CHAR: StringName = &'E'
const DESTINATION_CHAR: StringName = &'D'

const DUNGEON_SIZE: Vector2i = Vector2i(DUNGEON_HEIGHT, DUNGEON_WIDTH)
const DUNGEON_BOUNDARIES: Rect2i = Rect2i(Vector2i.ZERO, DUNGEON_SIZE)

const COMMAND_EAST: StringName = &'east'
const COMMAND_WEST: StringName = &'west'
const COMMAND_NORTH: StringName = &'north'
const COMMAND_SOUTH: StringName = &'south'
const COMMAND_TOTEM: StringName = &'totem'
const COMMAND_SCAN: StringName = &'scan'
const COMMAND_ATTACK: StringName = &'attack'
const COMMAND_DISARM: StringName = &'disarm'

const ROOM_ENTRANCE: StringName = &'E'
const ROOM_DESTINATION: StringName = &'D'
const ROOM_EMPTY: StringName = &'1'
const ROOM_CHEST: StringName = &'2'
const ROOM_HOLE: StringName = &'4'
const ROOM_MONSTER: StringName = &'5'
const ROOM_TRAP: StringName = &'6'
const ROOM_TOTEM: StringName = &'T'

const ROOM_NAMES: Dictionary[StringName, String] = {
	ROOM_ENTRANCE: "entrada",
	ROOM_DESTINATION: "destino",
	ROOM_EMPTY: "vazio",
	ROOM_CHEST: "baú",
	ROOM_HOLE: "buraco",
	ROOM_MONSTER: "monstro",
	ROOM_TRAP: "armadilha",
	ROOM_TOTEM: "totem"
}

const ROOM_HAZARDS: Array[StringName] = [
	ROOM_TRAP,
	ROOM_HOLE
]

const SCANNEABLE_ITEMS: Array[StringName] = [
	ROOM_TRAP,
	ROOM_HOLE,
	ROOM_MONSTER
]

const MAX_COMMANDS: int = 10

const EAST_MOVEMENT: Vector2i = Vector2i(0, 1)
const WEST_MOVEMENT: Vector2i = Vector2i(0, -1)
const NORTH_MOVEMENT: Vector2i = Vector2i(-1, 0)
const SOUTH_MOVEMENT: Vector2i = Vector2i(1, 0)

const ADJACENT_ROOMS: Array[Vector2i] = [
	Constants.EAST_MOVEMENT, 
	Constants.WEST_MOVEMENT, 
	Constants.NORTH_MOVEMENT, 
	Constants.SOUTH_MOVEMENT
]
