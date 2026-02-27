extends Control
@onready var credits_roller: PanelContainer = $CreditsRoller

func _ready() -> void:
	await get_tree().create_timer(.3).timeout
	credits_roller.start()
