extends Node

const SEPARATOR: String = "|"
const EXTRAS_CONFIG_PATH: String = "user://extras_config"

var available_extras: Array[MakingOf] = [
	preload("res://resources/making_of/objects/brainstorm.tres"),
	preload("res://resources/making_of/objects/color_study.tres"),
	preload("res://resources/making_of/objects/design_study.tres"),
	preload("res://resources/making_of/objects/playtest.tres"),
	preload("res://resources/making_of/objects/prototype.tres"),
	preload("res://resources/making_of/objects/sketches.tres")
]

func _ready() -> void:
	var discovered = load_settings()
	
	for extra in available_extras:
		extra.discovered = discovered.has(extra.id)
	
func load_settings() -> Array:
	var extras = []
	
	if !FileAccess.file_exists(EXTRAS_CONFIG_PATH):
		save_settings()
	else:
		var file = FileAccess.open(EXTRAS_CONFIG_PATH, FileAccess.READ)
		extras = file.get_line().split(SEPARATOR)
	
	return extras

func save_settings() -> void:
	var file = FileAccess.open(EXTRAS_CONFIG_PATH, FileAccess.WRITE)
	file.store_string(SEPARATOR.join(_map_discovered_extras()))
	file.close()

func has_any() -> bool:
	return available_extras.filter(func (e): return e.discovered).size()

func _map_discovered_extras() -> Array:
	return available_extras\
	.filter(func (e): return e.discovered)\
	.map(func (e): return e.id)
