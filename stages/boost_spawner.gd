extends Node2D

signal boost(boost_amount: float)

@export var spawn_point: Node2D
@export var boost_item: PackedScene
@export var spawn_delay: float = 1

@export var _spawn_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_timer.wait_time = spawn_delay
	_spawn_timer.one_shot = false
	_spawn_timer.start()



func _on_timer_timeout() -> void:
	var new_boost_item = boost_item.instantiate()
	new_boost_item.position = spawn_point.global_position
	new_boost_item.boost.connect(_on_boost)
	add_child(new_boost_item)

func _on_boost(boost_amount: float):
	boost.emit(boost_amount)
