extends Control

signal mining_complete(mined_percentage: float)

@export var normal_color: Color = Color.WHITE
@export var out_of_bounds_color: Color = Color.RED
@export var active_color: Color = Color.LIGHT_GREEN
@export var mined_color: Color = Color.DARK_GOLDENROD

@export var columns: int = 5
@export var rows: int = 5

@export var starting_position: Vector2 = Vector2(0, 0)
@export var out_of_bounds_growth_rate: float = 1


@export var _grid_container: GridContainer
@export var _mining_grid_space: PackedScene

@export var _heat_bar: ProgressBar
@export var heat_up_rate: float = 1
@export var heat_decay_rate: float = 1

@export var _debug_text: Label

var grid: Array
var current_position: Vector2
var fill_value: float
var fill_col: int
var mined_squares: int:
	set(value):
		mined_squares = value
		_debug_text.text = "{0}%".format([float(mined_squares) * 100 / total_squares])
var total_squares: int = 1
var is_game_over: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	mined_squares = 0
	total_squares = rows * columns
	
	for child in _grid_container.get_children():
		_grid_container.remove_child(child)
		child.queue_free()
	
	_grid_container.columns = columns
	grid = []
	grid.resize(rows)
	for r in rows:
		grid[r] = []
		grid[r].resize(columns)
		for c in columns:
			var grid_space = _mining_grid_space.instantiate()
			grid_space.base_color = normal_color
			grid_space.mined_color = mined_color
			grid_space.active_color = active_color
			grid_space.fill_color = out_of_bounds_color
			grid_space.fill_value = 0
			_grid_container.add_child(grid_space)
			grid[r][c] = grid_space
	
	current_position = starting_position
	grid[current_position.x][current_position.y].mine()
	grid[current_position.x][current_position.y].activate()
	fill_value = 0
	fill_col = 0
	is_game_over = false

func _process(delta):
	if !visible:
		return
	
	_check_game_over()
	if is_game_over:
		return
	_update_grid_bounds(delta)
	_update_heat_bar(delta)

func _input(event: InputEvent):
	if !visible:
		return
	if is_game_over:
		return
	
	var new_position = current_position
	
	if event.is_action_pressed("move_right"):
		new_position.y += 1
	if event.is_action_pressed("move_left"):
		new_position.y -= 1
	if event.is_action_pressed("move_up"):
		new_position.x -= 1
	if event.is_action_pressed("move_down"):
		new_position.x += 1
	get_viewport().set_input_as_handled()
	new_position.y = clamp(new_position.y, 0, columns - 1)
	new_position.x = clamp(new_position.x, 0, rows - 1)
	
	grid[current_position.x][current_position.y].deactivate()
	current_position = new_position
	if grid[current_position.x][current_position.y].mine():
		mined_squares += 1
	grid[current_position.x][current_position.y].activate()
	

# Processing Functions #
# # #
func _update_grid_bounds(delta):
	fill_value += delta * out_of_bounds_growth_rate
	while fill_col < int(fill_value) and fill_col < grid[0].size():
		for row in grid:
			row[fill_col].fill_value = 1
		fill_col += 1
	
	var is_grid_filled = func lambda():
		return fill_col >= grid[0].size()
	if is_grid_filled.call():
		return
	for row in grid:
		row[fill_col].fill_value = fill_value - int(fill_value)
		
func _update_heat_bar(delta):
	if _is_player_out_of_bounds():
		_heat_bar.value += delta * heat_up_rate
	else:
		_heat_bar.value -= delta * heat_decay_rate

# Utility Functions #
# # #
func _check_game_over():
	var game_over_check: bool = fill_col >= grid[0].size() or _heat_bar.value >= _heat_bar.max_value
	if not is_game_over and game_over_check:
		is_game_over = true
		mining_complete.emit(float(mined_squares) / total_squares)

func _is_player_out_of_bounds():
	return current_position.y <= fill_value
