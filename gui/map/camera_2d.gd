extends Camera2D

@export var zoom_speed: Vector2 = Vector2(1.1, 1.1)

# Private Variables
var _max_zoom: Vector2
var _min_zoom: Vector2
var _previousPosition: Vector2 = Vector2(0, 0)
var _moveCamera: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_zoom_in"):
		zoom *= zoom_speed
	if event.is_action_pressed("camera_zoom_out"):
		zoom /= zoom_speed
		
	_clamp_zoom()
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			_previousPosition = event.position
			_moveCamera = true
		else:
			_moveCamera = false
	elif event is InputEventMouseMotion && _moveCamera:
		var delta = (_previousPosition - event.position) / zoom
		position += delta
		_previousPosition = event.position


#func _unhandled_input(event: InputEvent):
	#if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		#get_viewport().set_input_as_handled()
		#if event.is_pressed():
			#_previousPosition = event.position
			#_moveCamera = true
		#else:
			#_moveCamera = false
	#elif event is InputEventMouseMotion && _moveCamera:
		#get_viewport().set_input_as_handled()
		#var delta = (_previousPosition - event.position) / zoom
		#position += delta
		#_previousPosition = event.position


func update_boundary(boundary: Rect2):
	limit_left = boundary.position.x
	limit_right = boundary.end.x
	limit_top = boundary.position.y
	limit_bottom = boundary.end.y
	
	var zoom_factor
	var sprite_ratio = boundary.size.x / boundary.size.y
	var viewport_ratio = get_viewport_rect().size.x / get_viewport_rect().size.y
	if sprite_ratio < viewport_ratio:
		zoom_factor = get_viewport_rect().size.x / boundary.size.x
	else:
		zoom_factor = get_viewport_rect().size.y / boundary.size.y
	_min_zoom = Vector2(zoom_factor, zoom_factor)
	_max_zoom = _min_zoom * 4
	_clamp_zoom()


func _clamp_zoom():
	zoom.x = clamp(zoom.x, _min_zoom.x, _max_zoom.x)
	zoom.y = clamp(zoom.y, _min_zoom.y, _max_zoom.y)


func _clamp_position(): # supposed to take care of clamping position
	var view_size = get_viewport_rect().size
	var x_offset = view_size.x / (2*zoom.x)
	var y_offset = view_size.y / (2*zoom.y)
	var x_bounds = clamp(position.x,limit_left+x_offset,limit_right-x_offset)
	var y_bounds = clamp(position.y,limit_top+y_offset,limit_bottom-y_offset)
	position = Vector2(x_bounds,y_bounds)
