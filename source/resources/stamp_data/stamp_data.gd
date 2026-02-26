extends Resource
class_name StampData

@export var command: StringName
@export var command_size: int = 1

@export var stamp_texture: Texture2D
@export var stamp_cursor: Texture2D

@export_range(0.01, 0.09, 0.01) var charge_use_rate: float = 0.09

const MAX_CHARGE: float = 1.0

var charge: float = MAX_CHARGE

func refill() -> void:
	charge = 1.0

func use() -> void:
	charge -= (charge_use_rate * command_size)
