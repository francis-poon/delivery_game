extends Node2D

var destination: String = ""
var travel_time: int = 0


func initiate_warp_drive():
	if destination == "":
		return
	print("Initiating warp to {0}. Arriving in {1} seconds.".format([destination, travel_time]))
	owner.destination_arrived.emit(destination)
	
func _on_new_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time
