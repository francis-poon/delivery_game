extends CanvasLayer

@export var _shop: Control
@export var _inventory: Control
@export var _map: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.hide()

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_map"):
		_map.visible = !_map.visible
	if event.is_action_pressed("toggle_inventory"):
		_inventory.visible = !_inventory.visible

	
func show_gui(gui_name: String) -> void:
	var target_gui: Array = find_children(gui_name, "Control", false, true)
	if target_gui.size() > 0:
		target_gui[0].show()
	
func hide_gui(gui_name: String) -> void:
	var target_gui: Array = find_children(gui_name, "Control", false, true)
	if target_gui.size() > 0:
		target_gui[0].hide()
	
func toggle_gui(gui_name: String) -> void:
	var target_gui: Array = find_children(gui_name, "Control", false, true)
	if target_gui.size() > 0:
		target_gui[0].visible = !target_gui[0].visible
		
