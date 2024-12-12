extends Control
class_name POIManager

signal poi_selected(poi: String)

var _poi_dictionary: Dictionary
var _active_poi: POIButton
var _poi_button_group: ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_poi_button_group = ButtonGroup.new()
	for child in get_children():
		if child is POIButton:
			child.pressed.connect(_on_pressed)
			child.button_group = _poi_button_group
			_poi_dictionary[child.poi] = child


func _on_pressed(poi: String):
	poi_selected.emit(poi)
	
func set_current_location(poi: String):
	if _active_poi:
		_active_poi.disable_current_location()
		
	if poi in _poi_dictionary:
		_active_poi = _poi_dictionary[poi]
		_active_poi.enable_current_location()
		
func get_poi_distance(poi_a: String, poi_b: String):
	if not (poi_a in _poi_dictionary and poi_b in _poi_dictionary):
		return -1
	return _poi_dictionary[poi_a].position.distance_to(_poi_dictionary[poi_b].position)
	
