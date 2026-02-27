extends Object
class_name Constants

const MAX_TOTEMS: int = 3

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

const ROOM_HOLE: StringName = &'4'
const ROOM_MONSTER: StringName = &'5'
const ROOM_TRAP: StringName = &'6'
const ROOM_TOTEM: StringName = &'T'

const ROOM_EXTRA_1: StringName = &'Z'
const ROOM_EXTRA_2: StringName = &'Y'
const ROOM_EXTRA_3: StringName = &'X'
const ROOM_EXTRA_4: StringName = &'W'
const ROOM_EXTRA_5: StringName = &'V'
const ROOM_EXTRA_6: StringName = &'U'

const ROOM_NAMES: Dictionary[StringName, String] = {
	ROOM_ENTRANCE: "entrada",
	ROOM_DESTINATION: "destino",
	ROOM_EMPTY: "vazio",
	ROOM_HOLE: "buraco",
	ROOM_MONSTER: "monstro",
	ROOM_TRAP: "armadilha",
	ROOM_TOTEM: "totem",
	ROOM_EXTRA_1: "baú",
	ROOM_EXTRA_2: "baú",
	ROOM_EXTRA_3: "baú",
	ROOM_EXTRA_4: "baú",
	ROOM_EXTRA_5: "baú",
	ROOM_EXTRA_6: "baú"
}

const ROOM_HAZARDS: Array[StringName] = [
	ROOM_TRAP,
	ROOM_HOLE
]

const SCANNEABLE_ITEMS: Array[StringName] = [
	ROOM_TRAP,
	ROOM_HOLE,
	ROOM_MONSTER,
	ROOM_EXTRA_1,
	ROOM_EXTRA_2,
	ROOM_EXTRA_3,
	ROOM_EXTRA_4,
	ROOM_EXTRA_5,
	ROOM_EXTRA_6
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

const MUSIC_VOLUME_KEY: String = "music_volume"
const SFX_VOLUME_KEY: String = "sfx_volume"

const DEFAULT_AUDIO_SETTINGS: Dictionary[StringName, float] = {
	MUSIC_VOLUME_KEY: 1,
	SFX_VOLUME_KEY: 1
}
