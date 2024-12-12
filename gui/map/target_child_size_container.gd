@tool

extends Control
class_name TargetChildSizeContainer

@export var _reference_child: Control
@export var _target_child: Control

@export var x_padding: float
@export var y_padding: float

# TODO: Try putting this control in an hboxcontainer and then setting the min size
# instead of the size in order to keep the whole thing centered
# Called when the node enters the scene tree for the first time.
func _ready():
	_reference_child.resized.connect(_update_target)

func _process(delta):
	if Engine.is_editor_hint():
		_update_target()
		
func _update_target():
	_target_child.size = _reference_child.size
	_target_child.size += Vector2(x_padding, y_padding)
	
	_target_child.position = _reference_child.position
	_target_child.position += Vector2(-x_padding/2, -y_padding/2)
