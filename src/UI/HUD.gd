extends Control

onready var black_screen: ColorRect = get_node("black_screen")
onready var scene_tree: = get_tree()
var paused: bool = false setget set_paused

func _input(event):
	if event.is_action_pressed("pause"):
		self.set_paused(!paused)
		#scene_tree.set_input_as_handled()

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	black_screen.visible = value


func _on_resume_btn_button_up():
	self.paused = false


func _on_quit_btn_button_up():
	scene_tree.quit()
