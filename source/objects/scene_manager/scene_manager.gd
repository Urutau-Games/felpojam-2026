extends CanvasLayer

enum Scene{
	TITLE,
	PLAY,
	INSTRUCTIONS,
	CREDITS
}

var _scenes: Dictionary[Scene, PackedScene] = {
	Scene.TITLE: preload("res://screens/title/title_screen.tscn"),
	Scene.PLAY: preload("res://screens/player_board/player_board.tscn")
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
