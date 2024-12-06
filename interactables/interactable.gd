extends Node2D
class_name Interactable

var interactable: bool = false

func interact():
	pass

# TODO: Might not be necessary to have these anymore
func _on_area_2d_area_entered(area: Area2D):
	if area.name == "Player":
		interactable = true

func _on_area_2d_area_exited(area):
	interactable = false
