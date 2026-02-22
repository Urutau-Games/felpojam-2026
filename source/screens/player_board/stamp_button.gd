extends TextureButton

var _hotspot: Vector2

@export var stamp_data: StampData

func _ready() -> void:
	_hotspot = texture_normal.get_size() / 2

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.hold_stamp(stamp_data, _hotspot)
	else:
		GameManager.drop_stamp()
	
