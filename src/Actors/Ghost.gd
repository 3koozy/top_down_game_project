extends KinematicBody2D

#Node:
onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape: CollisionPolygon2D = get_node("CollisionPolygon2D")
onready var damage_area: Area2D = get_node("damage_area")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var detection_area: Area2D = get_node("detection_area")
onready var feedback: = get_node("feedback")
#Variables:
export var direction: Vector2 = Vector2(0.0 , 1.0) #down by default
export var max_speed: int = 50
export var change_direction: bool = true
var motion: Vector2 = Vector2.ZERO
var enabled: bool = false
var chase_mode: bool = false
var chase_target : Node2D
var in_light: bool = false

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
		#check if we steped in light:
		if in_light:
			pass
		else:
			#check if we are chasing target:
			if chase_mode:
				var player_pos : Vector2 = chase_target.global_position
				var ghost_pos: Vector2 = self.global_position
				direction.x = player_pos.x - ghost_pos.x
				direction.y = player_pos.y - ghost_pos.y
				var larger_value = max(abs(direction.x) , abs(direction.y))
				direction.x /= larger_value
				direction.y /= larger_value
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
	#check if not chasing before randomly changing direction:
	if !chase_mode and !in_light:
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
	detection_area.monitoring = false
	anim_player.play("disappear_animation")

func enable():
	enabled = true
	collision_shape.disabled = false
	damage_area.monitorable = true
	detection_area.monitoring = true
	anim_player.play("appear_animation")

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		chase_mode = true
		chase_target = body
		feedback.show_feedback("ummm.. fresh meat" , "y")


func _on_detection_area_body_exited(body):
	if body.name == "Player":
		chase_mode = false
		chase_target = null
		feedback.show_feedback("too fast >_<" , "y")


func _on_detection_area_area_entered(area):
	if area.name == "light_area":
		in_light = true
		#set ghost motion direction the oppisite of light area:
		var area_pos = area.global_position
		var ghost_pos = self.global_position
		direction.x = area_pos.x - ghost_pos.x
		direction.y = area_pos.y - ghost_pos.y
		var larger_value = -1 * max(abs(direction.x) , abs(direction.y)) #negative for oppisite direction
		direction.x /= larger_value
		direction.y /= larger_value
		feedback.show_feedback("oh no ,light!!!!" , "y")
		


func _on_detection_area_area_exited(area):
	if area.name == "light_area":
		in_light = false
		feedback.show_feedback("phew.." , "y")
