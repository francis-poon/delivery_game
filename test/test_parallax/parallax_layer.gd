extends ParallaxLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if not child is Sprite2D:
			break
		var calc_scale = get_viewport_rect().size / child.get_rect().size
		var target_scale = max(calc_scale.x, calc_scale.y)
		child.scale = Vector2(target_scale, target_scale)
		motion_mirroring = child.get_rect().size * child.scale
