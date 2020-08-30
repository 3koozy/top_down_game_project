extends Control

#nodes:
onready var health_label: Label = get_node("health_Label")
onready var score_label: Label = get_node("score_label")
onready var black_screen: ColorRect = get_node("black_screen")
onready var scene_tree: = get_tree()
onready var time_metrics_label: Label = get_node("time_metrics_label")
onready var laundry_label: Label = get_node("Carried_Laundry_Label")
#variables:
var paused: bool = false setget set_paused

func _input(event):
	if event.is_action_pressed("pause"):
		self.set_paused(!paused)
		#scene_tree.set_input_as_handled()

func _process(delta):
	#update HUD:
	health_label.text = "Health : %s / %s" % [Global_Variables.player_health , Global_Variables.player_max_health ]
	score_label.text = "Score : %s" % Global_Variables.score
	#update time labels:
	var time_msec: float = Time_System.get_local_time_msec()
	var game_time: float = Time_System.get_game_time_24h()
	var game_time_mins : int = (game_time - int(game_time)) * 60
	var time_of_day: String = Time_System.time_of_day
	time_metrics_label.text = "Time (msec) : %s\nGame Time (hours) : %s:%s %s\nTime of day : %s" % \
	[time_msec , int(game_time) , game_time_mins , "AM" if game_time < 12 else "PM" , time_of_day]
	#update laundry labels:
	var carried_laundry: String = ""
	for i in range(Global_Variables.carried_laundary.size()):
		carried_laundry += Global_Variables.carried_laundary[i] + " , "
	var carried_weight: int = 0
	for i in range(Global_Variables.carried_weight.size()):
		carried_weight += Global_Variables.carried_weight[i]
	laundry_label.text = "Carried Laundry : %s\nCarried Weight : %s / %s" % [carried_laundry , str(carried_weight) , str(Global_Variables.carry_capacity)]
	

func set_paused(value: bool):
	paused = value
	scene_tree.paused = value
	black_screen.visible = value


func _on_resume_btn_button_up():
	self.paused = false


func _on_quit_btn_button_up():
	scene_tree.quit()


func _on_menu_btn_button_up():
	self.paused = false
	get_tree().change_scene("res://src/Screens/Main_Menu.tscn")
