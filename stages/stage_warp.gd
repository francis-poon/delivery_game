extends Node2D

signal destination_arrived(destination: String)

var destination: String
var travel_time: int


func start():
	print("Traveling to {0} in {1} seconds".format([destination, travel_time]))
	$WarpTimer.wait_time = travel_time
	$WarpTimer.start()

func set_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time

func _on_new_destination(p_destination: String, p_travel_time: int):
	$WarpDriveManager._on_new_destination(p_destination, p_travel_time)

func _on_warp_complete():
	destination_arrived.emit(destination)
