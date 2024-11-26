extends Stage

signal destination_arrived(destination: String)

@export var _progress_bar: ProgressBar
@export var _boost_spawner: Node2D

var destination: String
var travel_time: int
var time_left: float

func _ready():
	_boost_spawner.boost.connect(_on_boost)

func start():
	print("Traveling to {0} in {1} seconds".format([destination, travel_time]))
	time_left = travel_time
	_progress_bar.max_value = travel_time
	_progress_bar.value = _progress_bar.max_value - time_left
	
func _process(delta):
	decrease_time_left(delta)

func set_destination(p_destination: String, p_travel_time: int):
	destination = p_destination
	travel_time = p_travel_time

func _on_new_destination(p_destination: String, p_travel_time: int):
	$WarpDriveManager._on_new_destination(p_destination, p_travel_time)

func _on_warp_complete():
	destination_arrived.emit(destination)
	
func decrease_time_left(delta: float):
	time_left -= delta
	_progress_bar.value = _progress_bar.max_value - time_left
	if time_left <= 0:
		_on_warp_complete()
		
func _on_boost(boost_amount: float):
	decrease_time_left(boost_amount)
	
