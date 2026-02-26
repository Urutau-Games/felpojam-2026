extends TextureButton

@export var stamp_data: StampData

func _ready() -> void:
	GameManager.stamp_dropped.connect(_on_stamp_dropped)

func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.hold_stamp(stamp_data)
	else:
		GameManager.drop_stamp()

func _on_stamp_dropped(_is_release: bool) -> void:
	stamp_data.refill()
