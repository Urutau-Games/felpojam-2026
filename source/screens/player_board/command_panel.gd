extends GridContainer

const MAX_SLOTS: int = 10

var used_slots: int = 0

var remaining_slots: int:
	get:
		return MAX_SLOTS - used_slots

#func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	#return data == "accept" or data == "reject"
#
#func _drop_data(at_position: Vector2, data: Variant) -> void:
	#if remaining_slots >= data.command_size:
		#var slot = 0
		#while slot < data.command_size:
			#var tile = get_child(used_slots)
			#tile.texture = data.stamp_textures[slot]
			#used_slots += 1
			#slot += 1
