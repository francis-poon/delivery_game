extends "res://interactables/interactable.gd"

# TODO: Remove %GUI reference and replace system with signals

@export var data: Resource

func _input(event: InputEvent):
	if event.is_action_pressed("interact") and interactable:
		%GUI.shop.update_shop_data(data)
		%GUI.toggle_gui("Shop")

func _on_area_2d_area_exited(area):
	super._on_area_2d_area_exited(area)
	%GUI.hide_gui("Shop")
