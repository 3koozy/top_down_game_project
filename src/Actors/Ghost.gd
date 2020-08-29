extends KinematicBody2D

#Node:
onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape: CollisionPolygon2D = get_node("CollisionPolygon2D")
onready var damage_area: Area2D = get_node("damage_area")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
#Variables:
export var direction: Vector2 = Vector2(0.0 , 1.0) #down by default
export var max_speed: int = 50
export var change_direction: bool = true
var motion: Vector2 = Vector2.ZERO
var enabled: bool = false

func _ready():
	if !change_direction:
		get_node("change_direction_timer").stop()
	Time_System.connect("night" , self , "enable")
	Time_System.connect("night_to_day" , self , "disable")
	#disabled by default:
	disable()

func _physics_process(delta):
	if enabled:
		#update animation:
		var animation: String = ""
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
		#check if hit obstacle:
		if is_on_wall():
			#reverse direction:
			direction.x *= -1
			direction.y *= -1
		#move ghost:
		motion.x = direction.x * max_speed * delta
		motion.y = direction.y * max_speed * delta
		move_and_slide(motion)


func _on_change_direction_timer_timeout():
	var chance: int = randi() % 11
	if chance == 10 : #1/10 chance
		#stop moving
		direction = Vector2.ZERO
	else:
		#change direction:
		direction.x = rand_range(-1.0 , 1.0)
		direction.y = rand_range(-1.0 , 1.0)

func disable():
	enabled = false
	collision_shape.disabled = true
	damage_area.monitorable = false
	anim_player.play("disappear_animation")

func enable():
	enabled = true
	collision_shape.disabled = false
	damage_area.monitorable = true
	anim_player.play("appear_animation")
