extends Node2D

@export var _camera: Camera2D
@export var _label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_label.text = str(_camera.position)
