extends KinematicBody2D

#variables:
onready var player_sprite: AnimatedSprite = get_node("AnimatedSprite")
export var player_max_speed = 200
export var player_max_health: int = 10
export var score: int = 0
var direction: String = "d"
var player_motion: Vector2 = Vector2(0,0)
var health: int = player_max_health # initially at maximum

func _physics_process(delta):
	#calculate motion and change animation:
	if Input.is_key_pressed(KEY_S):
		player_sprite.animation = "moving_down"
		direction = "d"
	elif Input.is_key_pressed(KEY_W):
		player_sprite.animation = "moving_up"
		direction = "u"
	elif Input.is_key_pressed(KEY_A):
		player_sprite.animation = "moving_left"
		direction = "l"
	elif Input.is_key_pressed(KEY_D):
		player_sprite.animation = "moving_right"
		direction = "r"
	else : 
		player_motion = Vector2(0,0)
		if direction == "d":
			player_sprite.animation = "stop_down"
		elif direction == "u":
			player_sprite.animation = "stop_up"
		elif direction == "l":
			player_sprite.animation = "stop_left"
		elif direction == "r":
			player_sprite.animation = "stop_right"
	#move the player:
	var direction: Vector2 = get_direction()
	player_motion.x = direction.x * player_max_speed * delta
	player_motion.y = direction.y * player_max_speed * delta
	move_and_slide(player_motion)

func get_direction() -> Vector2:
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		, Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return direction


func _on_player_area_area_entered(area):
	if area.name == "love_area":
		#increase health by 1:
		health = min(health+1 , player_max_health)
		Audio_System.kiss_sfx.play()
	elif area.name == "damage_area":
		#decrease health by 1:
		health = max(health-1 , 0)
		Audio_System.hurt_sfx.play()
