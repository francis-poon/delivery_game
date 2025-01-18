extends Node2D

@export var mark_as_handled: bool = false

func _input(event: InputEvent):
	if event.is_action_pressed("move_right"):
		print(name)
		if mark_as_handled:
			get_viewport().set_input_as_handled()
