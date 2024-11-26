extends Node2D

@export var scroll_speed: float = 100
@export var scroll_sprite: Sprite2D
@export var scroll_sprite_2: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll_sprite.offset.y = 0
	scroll_sprite_2.offset.y = -scroll_sprite_2.texture.get_height()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_sprite.offset.y += scroll_speed * delta
	if scroll_sprite.offset.y > scroll_sprite.texture.get_height():
		scroll_sprite.offset.y = scroll_sprite.offset.y - 2 * scroll_sprite.texture.get_height()
		
	scroll_sprite_2.offset.y += scroll_speed * delta
	if scroll_sprite_2.offset.y > scroll_sprite_2.texture.get_height():
		scroll_sprite_2.offset.y = scroll_sprite_2.offset.y - 2 * scroll_sprite_2.texture.get_height()
