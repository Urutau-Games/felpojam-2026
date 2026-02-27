extends Node

signal extra_found(extra: String)

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

var discovered_extras: Array[MakingOf]:
	get:
		return available_extras.filter(func (e): return e.discovered)

func _ready() -> void:
	var discovered = load_settings()
	
	extra_found.connect(_on_extra_found)
	
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
	return discovered_extras.size()

func has(extra: String) -> bool:
	return _map_discovered_extras().has(extra)

func find_by_id(id: String) -> MakingOf:
	for extra in available_extras:
		if extra.id == id:
			return extra
			
	return null

func _on_extra_found(found_extra: String) -> void:
	var extra = find_by_id(found_extra)
	if extra:
		extra.discovered = true
		save_settings()

func _map_discovered_extras() -> Array:
	return discovered_extras.map(func (e): return e.id)
