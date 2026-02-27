extends CanvasLayer

const NEW_LOG_LINE: String = "%s\n"
const COLOR_TEMPLATE: String = "[color=#%s]%s[/color]"

const HIGHLIGHT: String = "[color=#6e5026]%s[/color]"

const ITEM_TEMPLATE: String = "\t%s: %s"

@onready var log_field: RichTextLabel = %LogField

var normal_color: Color = Color.WHITE
var error_color: Color = Color.BROWN
var success_color: Color = Color.FOREST_GREEN

func _ready() -> void:
	GameManager.position_revealed.connect(_on_position_revealed)

	GameManager.command_started.connect(_on_command_started)
	GameManager.command_finished.connect(_on_command_finished)
	GameManager.command_failed.connect(_on_command_failed)

	GameManager.dungeon_changed.connect(_on_dungeon_changed)

	GameManager.scan_completed.connect(_on_scan_completed)

	GameManager.target_reached.connect(_on_target_reached)
	
	GameManager.construct_moved.connect(_on_construct_moved)
	
	_append_log("Painel de depuração! Pressione CTRL+D para alternar entre visível e invisível.")
	_append_log("Sinais conectados!")

func _on_position_revealed(room: Vector2i, content: StringName) -> void:
	_append_log("Chegou na sala %s. Dentro tem: %s." % [_highlight(room), _from_room(content)])

func _on_command_started(command_index: int) -> void:
	_append_log("Comando %s iniciado." % _highlight(command_index + 1))

func _on_command_finished(command_index: int) -> void:
	_append_log("Comando %s executado." % _highlight(command_index + 1))

func _on_command_failed(command_index: int) -> void:
	_append_fail_message("Comando %s falhou!" % _highlight(command_index + 1))

func _on_dungeon_changed(room: Vector2i, new_value: StringName) -> void:
	_append_log("Sala %s agora é %s" % [_highlight(room), _from_room(new_value)])

func _on_scan_completed(items: Dictionary[StringName, int]) -> void:
	_append_log("Análise concluída")
	_append_log("Resultados:")
	
	for item in items.keys():
		_append_log(ITEM_TEMPLATE % [_from_room(item), _highlight(items[item])])

func _on_target_reached() -> void:
	_append_success_message("Chegou no destino!")

func _on_construct_moved(from: Vector2i, to: Vector2i) -> void:
	_append_log("Moveu de %s para %s" % [from, to].map(_highlight))

func _append_log(message: String) -> void:
	log_field.text += NEW_LOG_LINE % message

func _append_fail_message(message: String) -> void:
	_append_log(COLOR_TEMPLATE % [error_color.to_html(false), message])
	
func _append_success_message(message: String) -> void:
	_append_log(COLOR_TEMPLATE % [success_color.to_html(false), message])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released(&"toggle_debug_layer"):
		visible = not visible

func _highlight(content: Variant) -> String:
	return HIGHLIGHT % str(content)

func _from_room(value: StringName) -> String:
	return _highlight(Constants.ROOM_NAMES[value])
