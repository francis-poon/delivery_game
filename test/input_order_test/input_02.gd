extends Node2D


func _input(event: InputEvent):
	if event.is_action_pressed("move_right"):
		print("Input")
		get_viewport().set_input_as_handled()
		
	
func _unhandled_input(event):
	if event.is_action_pressed("move_right"):
		print("Unhandled Input")
