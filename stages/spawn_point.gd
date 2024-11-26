extends Node2D
	
@onready var _follow :PathFollow2D = get_parent()


func _ready():
	_follow.progress_ratio = randf()
	_tween_spawn_point()

func _on_random_tick_timer_timeout():
	_tween_spawn_point()

func _tween_spawn_point():
	var tween :Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_follow, 'progress_ratio', randf(), 1)
