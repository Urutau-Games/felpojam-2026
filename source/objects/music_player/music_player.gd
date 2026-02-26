extends AudioStreamPlayer

@export var planning_phase_music: AudioStream
@export var menu_music: AudioStream
@export var action_phase_music: AudioStream

@export var fade_out_time: float = 0.3
@export var fade_in_time: float = 0.2

var _starting_volume: float

func _ready() -> void:
	_starting_volume = volume_linear
	stream = menu_music
	play()

func play_planning_phase() -> void:
	_switch_music(planning_phase_music)
	
func play_menu() -> void:
	_switch_music(menu_music)
	
func play_action() -> void:
	_switch_music(action_phase_music)

func _switch_music(new_stream: AudioStream) -> void:
	var tween := create_tween()
	tween.tween_property(self, 'volume_linear', 0, fade_out_time)
	tween.tween_callback(_change_and_play.bind(new_stream))
	tween.tween_property(self, 'volume_linear', _starting_volume, fade_in_time)

func _change_and_play(new_stream: AudioStream) -> void:
	stream = new_stream
	play()
