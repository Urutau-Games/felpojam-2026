extends Control
class_name MapTile

@export var starting_point_texture: Texture2D

@export_group("Textures")
@export_subgroup("Backgrounds")
@export var hidden_backgorund: Texture2D
@export var revealed_background: Texture2D
@export var exit_background: Texture2D

@export_subgroup("Icons")
@export var monster_icon: Texture2D
@export var hole_icon: Texture2D
@export var trap_icon: Texture2D
@export var exit_icon: Texture2D

@onready var background: TextureRect = %Background
@onready var icon: TextureRect = %Icon

@onready var _icon_map : Dictionary[String, Texture2D] = {
	Constants.ROOM_EMPTY: null,
	Constants.ROOM_HOLE: hole_icon,
	Constants.ROOM_MONSTER: monster_icon,
	Constants.ROOM_TRAP: trap_icon
}

func _ready() -> void:
	background.texture = hidden_backgorund
	icon.texture = null

func set_special_tile(room_value: StringName) -> void:
	if room_value == Constants.ROOM_ENTRANCE or room_value == Constants.ROOM_TOTEM:
		_set_as_starting_point()
	elif room_value == Constants.ROOM_DESTINATION:
		_set_as_exit_point()

func reveal(room_value: StringName) -> void:
	background.texture = revealed_background
	icon.texture = _icon_map[room_value]

func _set_as_starting_point() -> void:
	background.texture = starting_point_texture
	icon.texture = null

func _set_as_exit_point() -> void:
	background.texture = exit_background
	icon.texture = exit_icon
