extends Control

# TODO: how do i store a list of valid items and their ids that can be referenced? In
# the inventory dictionary, should i store the item ids or the item name?
#
# basic inventory wont have item descriptions or anything, just a list of names
# and the amount of the item in inventory

signal inventory_update(item_name: StringName, item_quantity: int)

# Resources
var _inventory_menu_item_scene: InventoryMenuItem = load("res://gui/inventory/inventory_menu_item.tscn").instantiate()

# Components
@export var _gold_amount_label: Label
@export var _inventory_menu_container: VBoxContainer

# Private Vars
# dictionary that holds <item_id, count>
var _inventory_count: Dictionary
# dictionary that holds <item_id, inventory menu item gui node>
var _inventory_menu_items: Dictionary
var gold: int:
	set(value):
		gold = value
		_gold_amount_label.text = str(gold)
		
# Test vars
var _starting_items = ["Steel", "Iron", "Coal"]

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in _inventory_menu_container.get_children():
		_inventory_menu_container.remove_child(child)
		
	_inventory_count = {}
	gold = 10
	for item in _starting_items:
		add_item(item, 1)
		

func _on_inventory_request(item_name: StringName):
	var item_quantity = 0 if not _inventory_count.has(item_name) else _inventory_count[item_name]	
	inventory_update.emit(item_name, item_quantity)

func _on_buy(item_name: StringName, buy_quantity: int, cost: int):
	if not _inventory_count.has(item_name):
		add_item(item_name, 0)
		
	# Also handles odd case of cost = 0
	if buy_quantity * cost <= gold:
		gold -= buy_quantity * cost
		add_item(item_name, buy_quantity)
	else:
		var affordable_quantity = int(gold/cost)
		gold -= affordable_quantity * cost
		add_item(item_name, affordable_quantity)
	
func _on_sell(item_name: StringName, sell_quantity: int, cost: int):
	if not _inventory_count.has(item_name):
		return
		
	var amount_sold = sell_quantity if sell_quantity <= _inventory_count[item_name] else _inventory_count[item_name]
	gold += amount_sold * cost
	remove_item(item_name, amount_sold)
	

# Returns dictionary that holds item ids and count
func get_all_items():
	return _inventory_count.duplicate(true)

# Returns the count of item by id
func get_item_count(id):
	if _inventory_count.has(id):
		return _inventory_count[id]
	return 0

func add_item(id, count):
	if _inventory_count.has(id):
		_inventory_count[id] += count
	else:
		_inventory_count[id] = count
		
	if _inventory_count[id] <= 0:
		_inventory_count.erase(id)
		
	_update_inventory_menu(id)

func remove_item(id, count):
	if _inventory_count.has(id):
		_inventory_count[id] -= count
		if _inventory_count[id] <= 0:
			_inventory_count.erase(id)
			
	_update_inventory_menu(id)
	
func _update_inventory_menu(id):
	if _inventory_count.has(id):
		if _inventory_menu_items.has(id):
			_inventory_menu_items[id].count = _inventory_count[id]
		else:
			var menu_item:InventoryMenuItem = _inventory_menu_item_scene.duplicate()
			menu_item.item_name = id
			menu_item.count = _inventory_count[id]
			_inventory_menu_items[id] = menu_item
			_inventory_menu_container.add_child(menu_item)
	else:
		if _inventory_menu_items.has(id):
			_inventory_menu_container.remove_child(_inventory_menu_items[id])
			_inventory_menu_items[id].queue_free()
			_inventory_menu_items.erase(id)
