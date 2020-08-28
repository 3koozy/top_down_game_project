extends Node2D
class_name Blood , "res://assets/blood_a_2.png"

onready var anim_sprite: AnimatedSprite = get_node("AnimatedSprite")

func play():
	anim_sprite.play()

func _on_AnimatedSprite_animation_finished():
	queue_free()
