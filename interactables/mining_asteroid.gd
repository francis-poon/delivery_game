extends "res://interactables/interactable.gd"

@export var mining_interface: Control

func _ready():
	mining_interface.hide()

func interact():
	mining_interface.visible = !mining_interface.visible

func _on_area_2d_area_exited(area):
	super._on_area_2d_area_exited(area)
	mining_interface.hide()

func _on_button_pressed():
	mining_interface.hide()
	print("Asteroid mined")
	queue_free()
