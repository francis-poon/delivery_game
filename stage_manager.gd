extends Node2D

signal stage_changed(stage_name: String, spawn_pos: Vector2)
signal warp_complete(stage_name: String)
signal item_drop(item_name: String, amount: int)
signal buy(item_name: StringName, quantity: int, cost: int)
signal sell(item_name: StringName, quantity: int, cost: int)
signal inventory_count_request(item_name: StringName)

@export var stages: Dictionary
@export var warp_stage: PackedScene
@export var unknown_stage: PackedScene

var destination: String = ""
var travel_time: int = 0

var current_stage: Stage:
	set(value):
		current_stage = value
		_on_stage_changed()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stage("space_station_a")

	
func run_warp_drive():
	if destination == "" or destination == current_stage.id:
		return
	remove_child(current_stage)
	current_stage.queue_free()
	
	var new_stage = warp_stage.instantiate()
	new_stage.set_destination(destination, travel_time)
	new_stage.destination_arrived.connect(_on_warp_complete)
	print("Warp spawn pos: {0}".format([current_stage.spawn_pos]))
	add_child(new_stage)
	print("Warp spawn pos: {0}".format([current_stage.spawn_pos]))
	current_stage = new_stage
	current_stage.start()
	
func _on_warp_complete(stage_name: String):
	print("Warp complete")
	print("Arriving at {0}".format([stage_name]))
	set_stage(stage_name)
	warp_complete.emit(stage_name)
	
func set_stage(stage_name: String):
	if current_stage:
		call_deferred("remove_child", current_stage)
		current_stage.queue_free()
	if stage_name not in stages.keys():
		current_stage = unknown_stage.instantiate()
	else:
		current_stage = stages[stage_name].instantiate()
		
	if current_stage.has_signal("item_drop"):
		current_stage.item_drop.connect(_on_item_drop)
	if current_stage.has_signal("buy"):
		current_stage.buy.connect(_on_buy)
	if current_stage.has_signal("sell"):
		current_stage.sell.connect(_on_sell)
	if current_stage.has_signal("inventory_count_request"):
		current_stage.inventory_count_request.connect(_on_inventory_count_request)
		
	add_child(current_stage)
	
func _on_stage_changed():
	stage_changed.emit(current_stage.id, current_stage.spawn_pos)
	
func _on_new_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time
	
func _on_item_drop(item_name: String, amount: int):
	item_drop.emit(item_name, amount)
	
func _on_buy(item_name: StringName, quantity: int, cost: int) -> void:
	buy.emit(item_name, quantity, cost)

func _on_sell(item_name: StringName, quantity: int, cost: int) -> void:
	sell.emit(item_name, quantity, cost)

func _on_inventory_count_request(item_name: StringName) -> void:
	inventory_count_request.emit(item_name)
	
func _on_inventory_update(item_name: StringName, item_quantity: int):
	if current_stage and current_stage.has_method("_on_inventory_update"):
		current_stage._on_inventory_update(item_name, item_quantity)
