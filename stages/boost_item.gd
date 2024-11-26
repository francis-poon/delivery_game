extends Node2D

signal boost(boost_amount: float)

@export var lifetime: float = 10
@export var speed: float = 100
@export var boost_amount: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = lifetime
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += speed * delta
	

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.name == "Player":
		boost.emit(boost_amount)
		queue_free()
