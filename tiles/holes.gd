extends TileMap

class_name Holes

func _ready():
	set_collision_layer_value(0, 0)
	set_collision_mask_value(0, 0)
	set_collision_layer_value(1, 0)
	set_collision_mask_value(1, 0)
	set_collision_layer_value(7, 1)
	set_collision_mask_value(7, 1)
