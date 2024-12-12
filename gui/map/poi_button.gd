extends Control
class_name POIButton

signal pressed(poi: String)

@export var poi: String = ""

@export var _label: Label
@export var _button: Button

var button_group: ButtonGroup:
	set(value):
		button_group = value
		_button.button_group = value

# Called when the node enters the scene tree for the first time.
func _ready():
	#pressed.connect(owner._on_button_pressed.bind(poi))
	_label.text = poi


func _on_button_pressed() -> void:
	pressed.emit(poi)
	
func enable_current_location():
	_button.disabled = true
	
func disable_current_location():
	_button.disabled = false
