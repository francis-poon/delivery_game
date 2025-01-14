extends "res://interactables/interactable.gd"

signal item_drop(item_name: String, amount: int)

@export var _mining_interface: Control

var item_drop_name: String = "Stone"
var base_item_drop_amount: int = 10

func _ready():
	_mining_interface.hide()

func interact():
	_mining_interface.visible = !_mining_interface.visible

func _on_area_2d_area_exited(area):
	super._on_area_2d_area_exited(area)
	_mining_interface.hide()

func _on_mining_complete(mined_percentage):
	_mining_interface.hide()
	var item_drop_amount = int(base_item_drop_amount * mined_percentage)
	item_drop.emit(item_drop_name, item_drop_amount)
	print("Asteroid mined")
	queue_free()
