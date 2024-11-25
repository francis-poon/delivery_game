extends Resource
class_name ShopItemData

@export var name: String
@export var description: String
@export var cost: int

func _init(p_name = "", p_description = "", p_cost = 0):
	name = p_name
	description = p_description
	cost = p_cost
