extends Node2D

onready var feedback_label: Label = get_node("feedback_Label")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func show_feedback(text: String , color: String):
	feedback_label.visible = true
	feedback_label.text = text
	anim_player.stop(true)
	if color == "g":
		anim_player.play("fade_green")
	elif color == "r":
		anim_player.play("fade_red")
	elif color == "y":
		anim_player.play("fade_yellow")
