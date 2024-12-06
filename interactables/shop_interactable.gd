extends "res://interactables/interactable.gd"

signal buy(item_name: StringName, quantity: int, cost: int)
signal sell(item_name: StringName, quantity: int, cost: int)
signal inventory_count_request(item_name: StringName)

@export var _shop_interface: Control

@export var data: Resource

func _ready():
	_shop_interface.hide()
	_shop_interface.update_shop_data(data)
		
func interact():
	_shop_interface.visible = !_shop_interface.visible

func _on_area_2d_area_exited(area):
	super._on_area_2d_area_exited(area)
	_shop_interface.hide()


# TODO: Replace StringName with String type
func _on_buy(item_name: StringName, quantity: int, cost: int) -> void:
	buy.emit(item_name, quantity, cost)


func _on_sell(item_name: StringName, quantity: int, cost: int) -> void:
	sell.emit(item_name, quantity, cost)


func _on_inventory_count_request(item_name: StringName) -> void:
	inventory_count_request.emit(item_name)
	
func _on_inventory_update(item_name: StringName, item_quantity: int):
	_shop_interface._on_inventory_update(item_name, item_quantity)
