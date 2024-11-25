extends Resource
class_name ShopData

@export var shop_items: Array[ShopItemData]

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_shop_items: Array[ShopItemData] = []):
	shop_items = p_shop_items
