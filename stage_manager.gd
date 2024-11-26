extends Node2D

signal stage_changed(stage_name: String)
signal warp_complete(stage_name: String)

@export var stages: Dictionary
@export var warp_stage: PackedScene
@export var unknown_stage: PackedScene

var destination: String = ""
var travel_time: int = 0

var current_stage: Node:
	set(value):
		current_stage = value
		_on_stage_changed()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stage("a")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func run_warp_drive():
	if destination == "" or destination == current_stage.name:
		return
	remove_child(current_stage)
	current_stage.queue_free()
	current_stage = warp_stage.instantiate()
	current_stage.set_destination(destination, travel_time)
	current_stage.destination_arrived.connect(_on_warp_complete)
	add_child(current_stage)
	current_stage.start()
	
func _on_warp_complete(stage_name: String):
	print("Warp complete")
	print("Arriving at {0}".format([stage_name]))
	set_stage(stage_name)
	warp_complete.emit(stage_name)
	
func set_stage(stage_name: String):
	if current_stage:
		remove_child(current_stage)
		current_stage.queue_free()
	if stage_name not in stages.keys():
		current_stage = unknown_stage.instantiate()
	else:
		current_stage = stages[stage_name].instantiate()
	add_child(current_stage)
	
func _on_stage_changed():
	stage_changed.emit(current_stage.name)
	
func _on_new_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time
