extends Control

var _current_music_linear_value: float = 1
var _current_sfx_linear_value: float = 1

@onready var music_slider: HSlider = $VBoxContainer/GridContainer/MusicSlider
@onready var effects_slider: HSlider = $VBoxContainer/GridContainer/EffectsSlider

func _ready() -> void:
	_current_music_linear_value = AudioManager.current[Constants.MUSIC_VOLUME_KEY]
	_current_sfx_linear_value = AudioManager.current[Constants.SFX_VOLUME_KEY]
	
	music_slider.set_value_no_signal(_current_music_linear_value)
	effects_slider.set_value_no_signal(_current_sfx_linear_value)


func _on_back_pressed() -> void:
	SceneManager.transition_to(SceneManager.Scene.TITLE)


func _on_music_slider_value_changed(value: float) -> void:
	_current_music_linear_value = value


func _on_effects_slider_value_changed(value: float) -> void:
	_current_sfx_linear_value = value


func _on_any_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioManager.current = {
			Constants.MUSIC_VOLUME_KEY: _current_music_linear_value,
			Constants.SFX_VOLUME_KEY: _current_sfx_linear_value
		}
		
		AudioManager.save_settings()
