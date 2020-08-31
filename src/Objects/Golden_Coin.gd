extends Node2D

export var coin_value: int = 50
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")


func _on_coin_area_body_entered(body):
	if body.name == "Player":
		Global_Variables.score += coin_value
		Audio_System.collect_coin_sfx.play()
		anim_player.play("fade")
