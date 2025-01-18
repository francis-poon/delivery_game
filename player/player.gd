extends CharacterBody2D

signal hit
signal warp_drive

enum CameraMode { FOLLOW, STATIC }
enum ControlMode { SPIN, STRAFE }

@export var thrust_speed: float = 0.8
@export var break_speed: float = 0.2
@export var rotation_speed: float = 10

@export var warp_vertical_speed = 50
@export var warp_horizontal_speed = 50

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
var _input_is_breaking: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	_animation_tree.set("parameters/blend_position", Vector2.ZERO)


func _physics_process(delta):
	match control_mode:
		ControlMode.SPIN:
			if _input_is_breaking:
				velocity.x = lerpf(velocity.x, 0, break_speed)
				velocity.y = lerpf(velocity.y, 0, break_speed)
			else:
				var input_dir = Vector2.ZERO
				input_dir.y = _input_vector.y
				velocity += input_dir.rotated(rotation) * thrust_speed
			var rotate_dir = _input_vector.x
			var animation_vector = Vector2(0, _input_vector.y)
			animation_vector.x = rotate_dir
			_animation_tree.set("parameters/blend_position", animation_vector.normalized())
			rotate(rotate_dir * rotation_speed * delta)
			move_and_collide(velocity * delta)
		ControlMode.STRAFE:
			var input_dir = _input_vector
			velocity = input_dir.rotated(rotation)
			velocity.x *= warp_horizontal_speed
			velocity.y *= warp_vertical_speed
			
			_animation_tree.set("parameters/blend_position", velocity.normalized())
		
			move_and_collide(velocity * delta)


func _input(event: InputEvent):
	if event.is_action_pressed("warp_drive"):
		warp_drive.emit()
	if event.is_action_pressed("interact") and interactable:
		interactable.interact()
		_clear_inputs()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("move_right"):
		_input_vector.x += 1
	if event.is_action_pressed("move_left"):
		_input_vector.x += -1
	
	if event.is_action_pressed("move_up"):
		_input_vector.y += -1
	if event.is_action_pressed("move_down"):
		_input_vector.y += 1
		
	if event.is_action_released("move_right"):
		_input_vector.x = 0
	if event.is_action_released("move_left"):
		_input_vector.x = 0
	
	if event.is_action_released("move_up"):
		_input_vector.y = 0
	if event.is_action_released("move_down"):
		_input_vector.y = 0
		
	if event.is_action_pressed("break"):
		_input_is_breaking = true
	if event.is_action_released("break"):
		_input_is_breaking = false
	
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

func _clear_inputs():
	_input_vector = Vector2.ZERO
	_input_is_breaking = false

func _on_area_2d_area_entered(area: Area2D):
	if area.owner is Interactable:
		interactable = area.owner


func _on_area_2d_area_exited(area: Area2D):
	if interactable and area.owner == interactable:
		print("Interactable exiting")
		interactable = null
