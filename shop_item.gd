extends Control
class_name ShopItem

# Signals
signal shop_item_selected(item_name: StringName)

# Components
@export var item_name_label: Label
@export var item_name: StringName:
	set(value):
		item_name = value
		item_name_label.text = value
@export var item_description: String
@export var item_cost: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	shop_item_selected.emit(item_name, item_description, item_cost)
