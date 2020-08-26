extends Node2D

onready var health_label: Label = get_node("HUD/HUD/health_Label")
onready var score_label: Label = get_node("HUD/HUD/score_label")
onready var player: KinematicBody2D = get_node("Player")

func _ready():
	Audio_System.Background_music.play()

func _process(delta):
	#update HUD:
	health_label.text = "Health : %s" % player.health
	score_label.text = "Score : %s" % player.score