class_name MiningGridSpace
extends Control

var base_color: Color
var mined_color: Color
var active_color: Color

@export var fill_color: Color:
	set(value):
		fill_color = value
		var fill_stylebox = StyleBoxFlat.new()
		fill_stylebox.bg_color = value
		_progress_bar.add_theme_stylebox_override("fill", fill_stylebox)
		
@export var fill_value: float:
	set(value):
		fill_value = min(value, _progress_bar.max_value)
		_progress_bar.value = fill_value
		
@export var _color_rect: ColorRect
@export var _progress_bar: ProgressBar

var mined: bool

func _ready():
	mined = false
	fill_value = 0
	_color_rect.color = base_color

func mine() -> bool:
	if mined:
		return false
	mined = true
	_color_rect.color = mined_color
	return true
	
func activate():
	_color_rect.color = active_color
	
func deactivate():
	_color_rect.color = mined_color if mined else base_color
