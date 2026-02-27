extends PanelContainer

@export var making_of: MakingOf
@export var unknown_texture: Texture2D
@export var action_button_delay: float = 0.5

@onready var frame: TextureButton = $Frame
@onready var overlay: CanvasLayer = $Overlay

@onready var full_picture: TextureRect = $Overlay/Control/Panel/MarginContainer/HBoxContainer/FullPicture
@onready var title: Label = %Title
@onready var description: Label = %Description

func _ready() -> void:
	if making_of and making_of.discovered:
		frame.texture_normal = making_of.thumb
		
		full_picture.texture = making_of.overlay
		title.text = making_of.title
		description.text = making_of.description
	else:
		frame.texture_normal = unknown_texture

func _on_close_pressed() -> void:
	await _action_timer().timeout
	overlay.visible = false

func _action_timer() -> SceneTreeTimer:
	return get_tree().create_timer(action_button_delay)

func _on_frame_pressed() -> void:
	await _action_timer().timeout
	if making_of and making_of.discovered:
		overlay.visible = true
