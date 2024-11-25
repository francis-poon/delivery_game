extends Node2D

@export var data: Resource

var interactable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event: InputEvent):
	if event.is_action_pressed("interact") and interactable:
		%GUI.shop.update_shop_data(data)
		%GUI.toggle_gui("Shop")


func _on_area_2d_area_entered(area: Area2D):
	if area.name == "Player":
		interactable = true


func _on_area_2d_area_exited(area):
	interactable = false
	%GUI.hide_gui("Shop")
