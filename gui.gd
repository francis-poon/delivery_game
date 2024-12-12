extends Node2D

@export var inventory: Control
@export var map: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.hide()
	map.disable()

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_map"):
		map.toggle()
		#inventory.visible = false
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = !inventory.visible

	
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
		
