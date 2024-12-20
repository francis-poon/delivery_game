extends ParallaxLayer

@export var target: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():	
		var calc_scale = get_viewport_rect().size / child.get_rect().size
		var target_scale = max(calc_scale.x, calc_scale.y)
		child.scale = Vector2(target_scale, target_scale)
		motion_mirroring = target.get_rect().size * target.scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
