extends Control

signal new_destination_selected(destination: String, travel_time: int)

@export var current_location_text: Label

var current_location: String = "":
	set(value):
		current_location = value
		current_location_text.text = value
var destination: String = ""

func _ready():
	hide()

func _on_button_pressed(p_destination: String):
	print("{0} selected".format([p_destination]))
	destination = p_destination
	var travel_time: int = get_travel_time(current_location, destination)
	new_destination_selected.emit(destination, travel_time)
	
func get_travel_time(point_a: String, point_b: String) -> int:
	return 20
	
func _input(event: InputEvent):
	if event.is_action_pressed("toggle_map"):
		visible = !visible
		
func _on_destination_arrived(p_destination: String):
	current_location = p_destination
	destination = ""
	print("Map at {0}".format([current_location]))
	new_destination_selected.emit(destination, 0)
