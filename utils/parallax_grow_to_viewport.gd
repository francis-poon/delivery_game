extends Node2D

@export var _parallax_layer: ParallaxLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in _parallax_layer.get_children():
		if not child is Sprite2D:
			break
		var calc_scale = get_viewport_rect().size / (child.get_rect().size * child.scale)
		var target_scale = max(calc_scale.x, calc_scale.y)
		# Scale child to fill 
		if target_scale > 1:
			child.scale *= Vector2(target_scale, target_scale)
		
		_parallax_layer.motion_mirroring = child.get_rect().size * child.scale
