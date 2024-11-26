extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.warp_drive.connect($StageManager.run_warp_drive)
	$StageManager.stage_changed.connect(_on_stage_changed)
	%GUI/Map.new_destination_selected.connect($StageManager._on_new_destination)
	$StageManager.warp_complete.connect(%GUI/Map._on_destination_arrived)
	
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
