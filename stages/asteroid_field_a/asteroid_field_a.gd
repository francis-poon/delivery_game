extends "res://stages/stage.gd"

signal item_drop(item_name: String, amount: int)


func _on_mining_asteroid_item_drop(item_name, amount):
	item_drop.emit(item_name, amount)
