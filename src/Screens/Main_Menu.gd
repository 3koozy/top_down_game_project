extends Control

onready var main_level_path: String = "res://src/Levels/Main_Level.tscn"

func _ready():
	if !Audio_System.Background_music.playing:
		Audio_System.Background_music.play()

func _on_play_btn_button_up():
	get_tree().change_scene(main_level_path)


func _on_quit_button_button_up():
	get_tree().quit()
