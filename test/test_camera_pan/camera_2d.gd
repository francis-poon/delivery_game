extends Camera2D

var vel: float = 100
var zoom_speed: Vector2 = Vector2(1.1, 1.1)
var max_zoom: Vector2
var min_zoom: Vector2

@export var _sprite: Sprite2D
@export var _zoom_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprite_rect = _sprite.get_rect()
	sprite_rect.position *=  _sprite.scale
	sprite_rect.size *= _sprite.scale
	print(sprite_rect)
	print(get_viewport_rect().size)
	limit_left = sprite_rect.position.x
	limit_right = sprite_rect.end.x
	limit_top = sprite_rect.position.y
	limit_bottom = sprite_rect.end.y
	
	var zoom_factor
	var sprite_ratio = sprite_rect.size.x / sprite_rect.size.y
	var viewport_ratio = get_viewport_rect().size.x / get_viewport_rect().size.y
	if sprite_ratio < viewport_ratio:
		zoom_factor = get_viewport_rect().size.x / sprite_rect.size.x
	else:
		zoom_factor = get_viewport_rect().size.y / sprite_rect.size.y
	min_zoom = Vector2(zoom_factor, zoom_factor)
	max_zoom = min_zoom * 4
	_clamp_zoom()
	
	print("min zoom ", min_zoom)
	print("max zoom ", max_zoom)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_left"):
		position.x -= delta * vel
	if Input.is_action_pressed("move_right"):
		position.x += delta * vel
	if Input.is_action_pressed("move_up"):
		position.y -= delta * vel
	if Input.is_action_pressed("move_down"):
		position.y += delta * vel
	
	_clamp_position()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		zoom *= zoom_speed
	if event.is_action_pressed("camera_zoom_out"):
		zoom /= zoom_speed
		
	_clamp_zoom()

func _clamp_zoom():
	zoom.x = clamp(zoom.x, min_zoom.x, max_zoom.x)
	zoom.y = clamp(zoom.y, min_zoom.y, max_zoom.y)
	_zoom_label.text = str(zoom)

func _clamp_position(): # supposed to take care of clamping position
	var view_size = get_viewport_rect().size
	var x_offset = view_size.x / (2*zoom.x)
	var y_offset = view_size.y / (2*zoom.y)
	var x_bounds = clamp(position.x,limit_left+x_offset,limit_right-x_offset)
	var y_bounds = clamp(position.y,limit_top+y_offset,limit_bottom-y_offset)
	position = Vector2(x_bounds,y_bounds)

var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		if event.is_pressed():
			_previousPosition = event.position
			_moveCamera = true
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion && _moveCamera:
		get_viewport().set_input_as_handled()
		var delta = (_previousPosition - event.position) / zoom
		position += delta
		_previousPosition = event.position
