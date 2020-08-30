extends KinematicBody2D

#Node:
onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var collision_shape: CollisionPolygon2D = get_node("CollisionPolygon2D")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var detection_area: Area2D = get_node("detection_area")
onready var feedback: = get_node("feedback")
onready var chase_timer: Timer = get_node("chase_timer")
#Variables:
export var direction: Vector2 = Vector2(0.0 , 1.0) #down by default
export var max_speed: int = 50
export var change_direction: bool = true
var motion: Vector2 = Vector2.ZERO
var chase_mode: bool = false
var chase_target : Node2D
var running: bool = false
var running_from: Node
var sticky_laundry: Node
var speed_multplier: int = 1
var dead: bool = false

func _ready():
	if !change_direction:
		get_node("change_direction_timer").stop()

func _physics_process(delta):
	#stop any processing if dead:
	if dead: return
	#update animation:
	var animation: String = ""
	#check direction:
	if direction.x > 0: #right
		animation = "moving_right"
	elif direction.x < 0: #left
		animation = "moving_left"
	elif direction.y < 0: #up
		animation = "moving_up"
	elif direction.y > 0: #down
		animation = "moving_down"
	else : animation = "moving_down"
	#set animation:
	sprite.animation = animation
	#check if we steped in light:
	#check if we are chasing target:
	if running:
		var player_pos : Vector2 = running_from.global_position
		var slime_pos: Vector2 = self.global_position
		direction.x = player_pos.x - slime_pos.x
		direction.y = player_pos.y - slime_pos.y
		var larger_value = -1 * max(abs(direction.x) , abs(direction.y)) #negative to point to oppisite direction
		direction.x /= larger_value
		direction.y /= larger_value
		print("running : " + str(direction))
	else:
		if chase_mode:
			var laundry_pos : Vector2 = chase_target.global_position
			var slime_pos: Vector2 = self.global_position
			direction.x = laundry_pos.x - slime_pos.x
			direction.y = laundry_pos.y - slime_pos.y
			var larger_value = max(abs(direction.x) , abs(direction.y))
			direction.x /= larger_value
			direction.y /= larger_value
		#check if hit obstacle:
		elif is_on_wall():
			#reverse direction:
			direction.x *= -1
			direction.y *= -1
	#move ghost:
	motion.x = direction.x * max_speed * speed_multplier * delta
	motion.y = direction.y * max_speed * speed_multplier * delta
	move_and_slide(motion)
	#check sticky laundry:
	if sticky_laundry != null:
		sticky_laundry.global_position = self.global_position


func _on_change_direction_timer_timeout():
	#check if not chasing before randomly changing direction:
	if !chase_mode:
		var chance: int = randi() % 11
		if chance == 10 : #1/10 chance
			#stop moving
			direction = Vector2.ZERO
		else:
			#change direction:
			direction.x = rand_range(-1.0 , 1.0)
			direction.y = rand_range(-1.0 , 1.0)
		#should we drop the laundry ?:
		if sticky_laundry != null:
			chance = randi() % 6
			if chance == 5: #1/5 = 20% chance
				sticky_laundry = null
				feedback.show_feedback("pff... it's getting boaring!" , "y")

func _on_detection_area_body_entered(body):
	if body.name == "Player":
		#run away:
		running = true
		running_from = body
		#double the speed:
		speed_multplier = 3
		feedback.show_feedback("scarry human!" , "y")


func _on_detection_area_body_exited(body):
	if body.name == "Player":
		#stop running:
		running = false
		running_from = null
		speed_multplier = 1


func _on_detection_area_area_entered(area):
	if area.name == "laundry_area":
		#check if already have sticky laundry:
		if sticky_laundry == null and !running:
			#set slime motion direction the laundry area:
			chase_timer.start()
			if chase_target == null: #only if there is no prior target
				chase_target = area.get_parent()
				feedback.show_feedback("delicious laundry!!" , "y")
		

func _on_detection_area_area_exited(area):
	if area.name == "laundry_area":
		#you stop chasing when target laundry is out of sight:
		var exited_laundry = area.get_parent()
		if exited_laundry == chase_target:
			chase_mode = false
			chase_target = null
			feedback.show_feedback("where's my yummies??!" , "y")


func _on_touch_area_area_entered(area):
	if area.name == "laundry_area":
		sticky_laundry = area.get_parent()
		chase_mode = false
		chase_target = null
		feedback.show_feedback("yummy... :D" , "y")
	elif area.name == "damage_area" or area.name == "fist_area":
		feedback.show_feedback("ouch!" , "r")
		anim_player.play("die_animation")


func _on_chase_timer_timeout():
	#only of chase target still in range:
	if chase_target != null:
		chase_mode = true

func be_dead():
	dead = true
