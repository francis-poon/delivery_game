extends Control

# Signals
signal buy(item_name: StringName, quantity: int, cost: int)
signal sell(item_name: StringName, quantity: int, cost: int)
signal inventory_count_request(item_name: StringName)

# Resources
@export var shop_item_res: PackedScene

# Components
@export var shop_item_container: Control
@export var shop_item_description: Label
@export var transaction_quantity: SpinBox
@export var inventory_quantity: Label
@export var item_info_panel_content: Control
@export var item_cost_label: Label

# Public Vars

# Private Vars
var selected_item: StringName
var shop_item_data: Array[ShopItemData]
var selected_item_cost: int:
	set(value):
		selected_item_cost = value
		selected_item_total_cost = selected_item_cost * transaction_quantity.value
var selected_item_total_cost: int:
	set(value):
		selected_item_total_cost = value
		item_cost_label.text = str(value)


# Test Vars
#var TEST_shop_item_list: Array = ["Eggs", "Milk", "Bacon", "Cheese", "Spaghetti", "Bread", "Chicken"]

# Called when the node enters the scene tree for the first time.
func _ready():
	item_info_panel_content.hide()
	refresh_shop_listing()
	
func _on_shop_item_selected(item_name: String, item_description: String, item_cost: int):
	item_info_panel_content.show()
	shop_item_description.text = item_description
	selected_item = item_name
	selected_item_cost = item_cost
	
	# Update inventory quantity
	# send signal asking for inventory information
	# TODO: have listener that listens for inventory info and checks that the item
	# matches the one that the request was sent for?
	inventory_count_request.emit(selected_item)
	
func _on_buy():
	# Grab quantity to buy
	var buy_quantity: int = transaction_quantity.value
	
	# Send signal with item, and quantity
	if selected_item:
		buy.emit(selected_item, buy_quantity, selected_item_cost)
		inventory_count_request.emit(selected_item)
	
func _on_sell():
	# Grab quantity to sell
	var sell_quantity: int = transaction_quantity.value
	
	# Send signal with item and quantity
	if selected_item:
		sell.emit(selected_item, sell_quantity, selected_item_cost)
		inventory_count_request.emit(selected_item)
	
func _on_inventory_update(item_name: StringName, item_quantity: int):
	# Update in inverntory quantity count
	if item_name == selected_item:
		inventory_quantity.text = str(item_quantity)
		
# TODO: Check where and if this is ever used
func update_shop_data(shop_data: ShopData):
	shop_item_data = shop_data.shop_items
	refresh_shop_listing()
	
# Removes and repopulates shop menu items based off of shop_item_data resource
func refresh_shop_listing():
	item_info_panel_content.hide()
	for child in shop_item_container.get_children():
		shop_item_container.remove_child(child)
		child.queue_free()
	for item in shop_item_data:
		var new_shop_item: ShopItem = shop_item_res.instantiate()
		new_shop_item.item_name = item.name
		new_shop_item.item_cost = item.cost
		new_shop_item.item_description = item.description
		new_shop_item.shop_item_selected.connect(_on_shop_item_selected)
		shop_item_container.add_child(new_shop_item)
		


func _on_quantity_spin_box_value_changed(value):
	selected_item_total_cost = selected_item_cost * value
