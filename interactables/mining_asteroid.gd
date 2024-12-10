extends "res://interactables/interactable.gd"

signal item_drop(item_name: String, amount: int)

@export var _mining_interface: Control

var item_drop_name: String = "Stone"
var item_drop_amount: int = 3

func _ready():
	_mining_interface.hide()

func interact():
	_mining_interface.visible = !_mining_interface.visible

func _on_area_2d_area_exited(area):
	super._on_area_2d_area_exited(area)
	_mining_interface.hide()

func _on_button_pressed():
	_mining_interface.hide()
	item_drop.emit(item_drop_name, item_drop_amount)
	print("Asteroid mined")
	queue_free()
