extends Control

signal inventory_update(item_name: StringName, item_quantity: int)

# Components
@export var gold_amount_label: Label

var item_inv: Dictionary
var gold: int:
	set(value):
		gold = value
		gold_amount_label.text = str(gold)

# Called when the node enters the scene tree for the first time.
func _ready():
	item_inv = {}
	gold = 10

	
func _on_inventory_request(item_name: StringName):
	var item_quantity = 0 if not item_inv.has(item_name) else item_inv[item_name]	
	inventory_update.emit(item_name, item_quantity)

func _on_buy(item_name: StringName, buy_quantity: int, cost: int):
	if not item_inv.has(item_name):
		item_inv[item_name] = 0
		
	# Also handles odd case of cost = 0
	if buy_quantity * cost <= gold:
		gold -= buy_quantity * cost
		item_inv[item_name] += buy_quantity
	else:
		var affordable_quantity = int(gold/cost)
		gold -= affordable_quantity * cost
		item_inv[item_name] += affordable_quantity
	
func _on_sell(item_name: StringName, sell_quantity: int, cost: int):
	if not item_inv.has(item_name):
		item_inv[item_name] = 0
		
	var amount_sold = sell_quantity if sell_quantity <= item_inv[item_name] else item_inv[item_name]
	gold += amount_sold * cost
	item_inv[item_name] -= amount_sold
