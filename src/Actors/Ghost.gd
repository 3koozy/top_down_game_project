extends KinematicBody2D

onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
var direction: Vector2 = Vector2(0.0 , 1.0) #down by default
var motion: Vector2 = Vector2.ZERO
export var max_speed: int = 50

func _physics_process(delta):
	#update animation:
	var animation: String = ""
	#check motion:
	#if motion != Vector2.ZERO: #moving
	#	animation = "moving_"
	#else : animation = "stop_"
	
	#check direction:
	if direction.x > 0: #right
		animation += "moving_right"
	elif direction.x < 0: #left
		animation += "moving_left"
	elif direction.y < 0: #up
		animation += "moving_up"
	elif direction.y > 0: #down
		animation += "moving_down"
	else : animation += "moving_down"
	#set animation:
	sprite.animation = animation
	#move ghost:
	motion.x = direction.x * max_speed * delta
	motion.y = direction.y * max_speed * delta
	move_and_collide(motion)


func _on_Timer_timeout():
	var chance: int = randi() % 11
	if chance == 10 : #1/10 chance
		#stop moving
		direction = Vector2.ZERO
	else:
		#change direction:
		direction.x = rand_range(-1.0 , 1.0)
		direction.y = rand_range(-1.0 , 1.0)


func _on_damage_area_area_entered(area):
	print("X_X")
