extends CharacterBody2D

signal hit
signal warp_drive

enum CameraMode { FOLLOW, STATIC }
enum ControlMode { SPIN, STRAFE }

@export var speed = 400
@export var rotation_speed = 10

@export var camera: Camera2D
@export var _animation_tree: AnimationTree

var screen_size
var control_mode: ControlMode
var interactable: Interactable:
	get():
		if !is_instance_valid(interactable):
			interactable = null
		return interactable
		
var _input_vector: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.set("parameters/blend_position", Vector2.ZERO)


func _physics_process(delta):
	match control_mode:
		ControlMode.SPIN:
			var input_dir = Vector2.ZERO
			input_dir.y = _input_vector.y
			var rotate_dir = _input_vector.x
			velocity = input_dir.rotated(rotation) * speed
			
			var animation_vector = input_dir
			animation_vector.x = rotate_dir
			_animation_tree.set("parameters/blend_position", animation_vector.normalized())
		
			rotate(rotate_dir * rotation_speed * delta)
			move_and_collide(velocity * delta)
		ControlMode.STRAFE:
			var input_dir = _input_vector
			velocity = input_dir.rotated(rotation) * speed
			
			_animation_tree.set("parameters/blend_position", velocity.normalized())
		
			move_and_collide(velocity * delta)
			
	

func _input(event: InputEvent):
	if event.is_action_pressed("warp_drive"):
		warp_drive.emit()
	if event.is_action_pressed("interact") and interactable:
		interactable.interact()

func _unhandled_input(event: InputEvent):
	_input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		_input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		_input_vector.x += -1
	
	if Input.is_action_pressed("move_up"):
		_input_vector.y += -1
	if Input.is_action_pressed("move_down"):
		_input_vector.y += 1
	
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


func _on_area_2d_area_entered(area: Area2D):
	if area.owner is Interactable:
		interactable = area.owner


func _on_area_2d_area_exited(area: Area2D):
	if interactable and area.owner == interactable:
		print("Interactable exiting")
		interactable = null
