extends Node2D

onready var sprite: AnimatedSprite = get_node("AnimatedSprite")


func _on_damage_area_body_entered(body):
	sprite.play("open_animation")


func _on_damage_area_body_exited(body):
	sprite.play("close_animation")
