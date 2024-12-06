extends "res://stages/stage.gd"

signal buy(item_name: StringName, quantity: int, cost: int)
signal sell(item_name: StringName, quantity: int, cost: int)
signal inventory_count_request(item_name: StringName)

@export var _shop: Node2D

func _on_buy(item_name: StringName, quantity: int, cost: int) -> void:
	buy.emit(item_name, quantity, cost)

func _on_sell(item_name: StringName, quantity: int, cost: int) -> void:
	sell.emit(item_name, quantity, cost)

func _on_inventory_count_request(item_name: StringName) -> void:
	inventory_count_request.emit(item_name)
	
func _on_inventory_update(item_name: StringName, item_quantity: int):
	_shop._on_inventory_update(item_name, item_quantity)
