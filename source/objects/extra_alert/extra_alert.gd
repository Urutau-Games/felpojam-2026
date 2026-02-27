extends Control

const INITIAL_POSITION: float = 2000
const DISPLAY_POSITION: float = 888

const MOVE_TIME: float = 0.2
const SHOW_TIME: float = 3.0

@onready var thumb_rect: TextureRect = %Thumb
@onready var title_label: Label = %Title

var thumb: Texture2D
var title: String

func _ready() -> void:
	global_position.y = INITIAL_POSITION
	
	thumb_rect.texture = thumb
	title_label.text = title
	
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", DISPLAY_POSITION, MOVE_TIME)
	tween.tween_interval(SHOW_TIME)
	tween.tween_property(self, "global_position:y", INITIAL_POSITION, MOVE_TIME)
	tween.tween_callback(self.queue_free)
