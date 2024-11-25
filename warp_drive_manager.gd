extends Node2D

signal destination_arrived(destination: String)

var destination: String = ""
var travel_time: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initiate_warp_drive():
	if destination == "":
		return
	print("Initiating warp to {0}. Arriving in {1} seconds.".format([destination, travel_time]))
	destination_arrived.emit(destination)
	
func _on_new_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time
