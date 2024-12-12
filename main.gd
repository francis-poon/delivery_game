extends Node2D

@export var gui: Node2D
@export var stage_manager: Node2D
@export var player: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	gui.map.new_destination_selected.connect(stage_manager._on_new_destination)
	
	gui.inventory.inventory_update.connect(stage_manager._on_inventory_update)
	
	stage_manager.stage_changed.connect(_on_stage_changed)
	stage_manager.stage_changed.connect(gui.map._on_destination_arrived)
	stage_manager.item_drop.connect(gui.inventory.add_item)
	stage_manager.buy.connect(gui.inventory._on_buy)
	stage_manager.sell.connect(gui.inventory._on_sell)
	stage_manager.inventory_count_request.connect(gui.inventory._on_inventory_request)
	
	player.warp_drive.connect(stage_manager.run_warp_drive)
	player.set_camera_mode(player.CameraMode.FOLLOW)
	player.set_control_mode(player.ControlMode.SPIN)
	
	stage_manager.set_stage("space_station_a")


func _on_stage_changed(stage_name: String, spawn_pos: Vector2):
	if stage_name == "warp":
		player.set_camera_mode(player.CameraMode.STATIC)
		player.set_control_mode(player.ControlMode.STRAFE)
	else:
		player.set_camera_mode(player.CameraMode.FOLLOW)
		player.set_control_mode(player.ControlMode.SPIN)
	player.position = spawn_pos
 
