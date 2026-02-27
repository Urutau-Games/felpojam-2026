extends CanvasLayer

enum Scene{
	TITLE,
	PLAY,
	INSTRUCTIONS,
	CREDITS,
	OPTIONS,
	EXTRA
}

var _scenes: Dictionary[Scene, PackedScene] = {
	Scene.TITLE: preload("res://screens/title/title_screen.tscn"),
	Scene.PLAY: preload("res://screens/player_board/player_board.tscn"),
	Scene.CREDITS: preload("res://screens/credits/credits_screen.tscn"),
	Scene.OPTIONS: preload("res://screens/options/options_screen.tscn"),
	Scene.EXTRA: preload("res://screens/extra/extra_screen.tscn")
}

var _spawn_position: Vector2

func _ready() -> void:
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")

	_spawn_position = Vector2(width, height) / 2

func transition_to(new_scene: Scene) -> void:
	_switch_scene(new_scene)

func _switch_scene(scene: Scene) -> void:
	get_tree().change_scene_to_packed(_scenes[scene])
