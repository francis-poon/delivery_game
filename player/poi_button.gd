extends Button

@export var poi: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(owner._on_button_pressed.bind(poi))
