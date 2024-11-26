extends CharacterBody2D

signal hit
signal warp_drive

enum CameraMode { FOLLOW, STATIC }
enum ControlMode { SPIN, STRAFE }

@export var speed = 400
@export var rotation_speed = 10

@export var camera: Camera2D

var screen_size
var control_mode: ControlMode

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimationPlayer.play("booster")


func _physics_process(delta):
	match control_mode:
		ControlMode.SPIN:
			var input_dir = Vector2.ZERO
			var rotate_dir = 0
			if Input.is_action_pressed("move_right"):
				rotate_dir = 1
			if Input.is_action_pressed("move_left"):
				rotate_dir = -1
			if Input.is_action_pressed("move_up"):
				input_dir.y -= 1
			if Input.is_action_pressed("move_down"):
				input_dir.y += 1
			velocity = input_dir.rotated(rotation) * speed
		
			rotate(rotate_dir * rotation_speed * delta)
			move_and_collide(velocity * delta)
		ControlMode.STRAFE:
			var input_dir = Vector2.ZERO
			if Input.is_action_pressed("move_right"):
				input_dir.x += 1
			if Input.is_action_pressed("move_left"):
				input_dir.x -= 1
			if Input.is_action_pressed("move_up"):
				input_dir.y -= 1
			if Input.is_action_pressed("move_down"):
				input_dir.y += 1
			velocity = input_dir.rotated(rotation) * speed
		
			move_and_collide(velocity * delta)
			
	

func _input(event: InputEvent):
	if event.is_action_pressed("warp_drive"):
		warp_drive.emit()

func _on_body_entered(body):
	print("player entered")
	
func set_camera_mode(mode: CameraMode):
	match mode:
		CameraMode.FOLLOW:
			camera.enabled = true
		CameraMode.STATIC:
			camera.enabled = false
			
func set_control_mode(mode: ControlMode):
	match mode:
		ControlMode.SPIN:
			control_mode = mode
		ControlMode.STRAFE:
			control_mode = mode
			rotation = 0
