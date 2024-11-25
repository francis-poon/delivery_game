extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.warp_drive.connect($WarpDriveManager.initiate_warp_drive)
	%GUI/Map.new_destination_selected.connect($WarpDriveManager._on_new_destination)
	$WarpDriveManager.destination_arrived.connect(%GUI/Map._on_destination_arrived)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
