extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	%GUI/Map.new_destination_selected.connect($StageManager._on_new_destination)
	
	%GUI/Inventory.inventory_update.connect($StageManager._on_inventory_update)
	
	$StageManager.stage_changed.connect(_on_stage_changed)
	$StageManager.warp_complete.connect(%GUI/Map._on_destination_arrived)
	$StageManager.item_drop.connect(%GUI/Inventory.add_item)
	$StageManager.buy.connect(%GUI/Inventory._on_buy)
	$StageManager.sell.connect(%GUI/Inventory._on_sell)
	$StageManager.inventory_count_request.connect(%GUI/Inventory._on_inventory_request)
	
	$Player.warp_drive.connect($StageManager.run_warp_drive)
	$Player.set_camera_mode($Player.CameraMode.FOLLOW)
	$Player.set_control_mode($Player.ControlMode.SPIN)


func _on_stage_changed(stage_name: String, spawn_pos: Vector2):
	if stage_name == "warp":
		$Player.set_camera_mode($Player.CameraMode.STATIC)
		$Player.set_control_mode($Player.ControlMode.STRAFE)
	else:
		$Player.set_camera_mode($Player.CameraMode.FOLLOW)
		$Player.set_control_mode($Player.ControlMode.SPIN)
	$Player.position = spawn_pos
 
