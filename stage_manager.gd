extends Node2D

signal stage_changed(stage_name: String)

@export var stages: Dictionary
@export var warp_stage: PackedScene
@export var unknown_stage: PackedScene

var current_stage: Node:
	set(value):
		current_stage = value
		_on_stage_changed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func run_warp_stage():
	remove_child(current_stage)
	current_stage.queue_free()
	current_stage = warp_stage.instantiate()
	add_child(current_stage)
	
func _on_warp_complete():
	print("Warp complete")
	print("Arriving at")
	# TODO: Move destination tracking from warp stage to here?
	
func set_stage(stage_name: String):
	remove_child(current_stage)
	current_stage.queue_free()
	if stage_name not in stages.keys:
		current_stage = unknown_stage.instantiate()
	else:
		current_stage = stages[stage_name].instantiate()
	add_child(current_stage)
	
func _on_stage_changed():
	stage_changed.emit(current_stage.name)
