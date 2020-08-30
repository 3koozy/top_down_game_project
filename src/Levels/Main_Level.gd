extends Node2D

onready var health_label: Label = get_node("HUD/HUD/health_Label")
onready var score_label: Label = get_node("HUD/HUD/score_label")
onready var player: KinematicBody2D = get_node("Player")

func _ready():
	Time_System.start_system()
