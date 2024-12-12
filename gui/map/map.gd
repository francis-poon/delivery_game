extends Node2D

signal new_destination_selected(destination: String, travel_time: int)

@export var _gui_canvas: CanvasLayer
@export var _current_location_text: Label
@export var _target_destination_label: Label
@export var _target_destination_panel: Control
@export var _travel_time_label: Label
@export var _camera: Camera2D
@export var _poi_manager: POIManager

@export var background: Sprite2D

var TRAVEL_TIME_FACTOR: float = 0.5

var current_location: String = "":
	set(value):
		current_location = value
		_current_location_text.text = value
		_poi_manager.set_current_location(value)
var destination: String = "":
	set(value):
		destination = value
		if value == "":
			_target_destination_panel.hide()
			_travel_time_label.hide()
		else:
			_target_destination_label.text = value
			_target_destination_panel.show()
			

func _ready() -> void:
	var boundary = background.get_rect()
	boundary.position *=  background.scale
	boundary.size *= background.scale
	
	_travel_time_label.hide()
	
	_camera.update_boundary(boundary)

func _on_poi_selected(poi: String):
	print("{0} selected".format([poi]))
	destination = poi
	var travel_time: int = get_travel_time(current_location, destination)
	print("Travel time: ", travel_time)
	_travel_time_label.show()
	_travel_time_label.text = _format_seconds(travel_time)
	new_destination_selected.emit(destination, travel_time)
	
func get_travel_time(point_a: String, point_b: String) -> int:
	var distance = _poi_manager.get_poi_distance(point_a, point_b)
	
	if distance < 0:
		return 20
	return distance * TRAVEL_TIME_FACTOR

	
func toggle():
	if visible:
		disable()
	else:
		enable()
		
func disable():
	visible = false
	_camera.enabled = false
	_gui_canvas.hide()
	
func enable():
	visible = true
	_gui_canvas.show()
	_camera.enabled = true
	_camera.make_current()
	
		
func _on_destination_arrived(p_destination: String, _spawn_point: Vector2):
	current_location = p_destination
	destination = ""
	print("Map at {0}".format([current_location]))
	new_destination_selected.emit(destination, 0)
	
func _format_seconds(seconds: int) -> String:
	var minutes = int(seconds / 60)
	var remainder_seconds = seconds % 60
	
	var output = "{0}s".format([remainder_seconds]) if minutes == 0 else "{0}m {1}s".format([minutes, remainder_seconds])
	
	
	return output
