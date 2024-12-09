extends Control
class_name InventoryMenuItem

# Components
@export var _item_name_label: Label
@export var _count_label: Label


# Public Vars
var item_name: String:
	set(value):
		item_name = value
		_item_name_label.text = value

var count: int:
	set(value):
		count = value
		_count_label.text = str(value)
