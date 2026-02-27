extends Node

const AUDIO_CONFIG_PATH: String = "user://audio_config"

var _music_bus_index: int
var _sfx_bus_index: int

var current: Dictionary:
	set(value):
		current = value
		AudioServer.set_bus_volume_linear(_music_bus_index, value[Constants.MUSIC_VOLUME_KEY])
		AudioServer.set_bus_volume_linear(_sfx_bus_index, value[Constants.SFX_VOLUME_KEY])
	get:
		return current

func _ready() -> void:
	_music_bus_index = AudioServer.get_bus_index("Music")
	_sfx_bus_index = AudioServer.get_bus_index("SFX")
	
	load_settings()

func load_settings() -> Dictionary:
	if not current:
		if !FileAccess.file_exists(AUDIO_CONFIG_PATH):
			current = Constants.DEFAULT_AUDIO_SETTINGS
			save_settings()
		else:
			var file = FileAccess.open(AUDIO_CONFIG_PATH, FileAccess.READ)
			current = from_json(file.get_as_text())
		
	return current

func save_settings() -> void:
	var file = FileAccess.open(AUDIO_CONFIG_PATH, FileAccess.WRITE)
	file.store_string(str(current))
	file.close()

func from_json(json: String) -> Dictionary:
		return JSON.parse_string(json)
