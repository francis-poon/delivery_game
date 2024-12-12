extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var a = Rect2(Vector2.ZERO, Vector2.ZERO)
	var b = a
	
	b.size = Vector2(1,1)
	print(a.size)
	b.size.x = 3
	print(a.size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
