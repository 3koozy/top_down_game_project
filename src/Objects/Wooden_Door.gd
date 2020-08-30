extends StaticBody2D

onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var collision: CollisionShape2D = get_node("CollisionShape2D")
var door_open: bool = false

func door_interaction():
	if door_open:
		close_door()
		door_open = false
	else:
		open_door()
		door_open = true

func open_door():
	sprite.play("open_animation")
	collision.disabled = true

func close_door():
	sprite.play("close_animation")
	collision.disabled = false
