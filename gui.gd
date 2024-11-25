extends CanvasLayer

@export var shop: Control
@export var inventory: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name == "Shop":
			child.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
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
		
