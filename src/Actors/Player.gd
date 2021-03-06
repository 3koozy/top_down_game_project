extends KinematicBody2D

#Nodes:
onready var player_sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var Feedback_Label: Label = get_node("Feedback_Label")
onready var dust_particles: Particles2D = get_node("Dust_Particles/Particles2D")
onready var heart_particles: Particles2D = get_node("hearts_particles/Particles2D")
onready var blood_anim: AnimatedSprite = get_node("blood_animated/AnimatedSprite")
onready var feedback: = get_node("feedback")
onready var player_area: Area2D = get_node("player_area")
onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
#Variables:
export var player_max_speed = 200
var direction: String = "d"
var player_motion: Vector2 = Vector2(0,0)

func _input(event):
	if event.is_action_released("interaction"):
		var overlapping_areas = player_area.get_overlapping_areas()
		#check if we are overlapping with a door:
		var door: Area2D = check_area_from("door_area" , overlapping_areas)
		if door != null:
			door.get_parent().door_interaction()
	elif event.is_action_released("hit"):
		var animation = anim_player.get_animation("hit_down")
		var direction: Vector2 = event.position - get_global_transform_with_canvas().origin
		var larger_value = max(abs(direction.x) , abs(direction.y))
		direction.x /= larger_value
		direction.y /= larger_value
		animation.track_set_key_value(0 , 1 , direction * Vector2(15 , 15))
		anim_player.play("hit_down")
		

func _physics_process(delta):
	#calculate motion and change animation:
	if Input.is_key_pressed(KEY_SHIFT):
		dust_particles.emitting = true
	else : dust_particles.emitting = false
	if Input.is_key_pressed(KEY_S):
		player_sprite.animation = "moving_down"
		direction = "d"
		dust_particles.rotation = deg2rad(90)
	elif Input.is_key_pressed(KEY_W):
		player_sprite.animation = "moving_up"
		direction = "u"
		dust_particles.rotation = deg2rad(-90)
	elif Input.is_key_pressed(KEY_A):
		player_sprite.animation = "moving_left"
		direction = "l"
		dust_particles.rotation = deg2rad(180)
	elif Input.is_key_pressed(KEY_D):
		player_sprite.animation = "moving_right"
		direction = "r"
		dust_particles.rotation = deg2rad(0)
	else : 
		dust_particles.emitting = false
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
	var motion_multiplier: int = 2 if Input.is_key_pressed(KEY_SHIFT) else 1
	player_motion.x = direction.x * player_max_speed * motion_multiplier * delta
	player_motion.y = direction.y * player_max_speed * motion_multiplier * delta
	move_and_slide(player_motion)

func get_direction() -> Vector2:
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		, Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	return direction

func check_area_from(area_name: String , array) -> Area2D:
	for i in range(array.size()):
		if array[i].name == area_name:
			return array[i]
	return null

func _on_player_area_area_entered(area):
	if area.name == "love_area":
		#increase health by 1:
		if Global_Variables.player_health < Global_Variables.player_max_health:
			Global_Variables.player_health += 1
			Audio_System.kiss_sfx.play()
			feedback.show_feedback("Health +1" , "g")
			heart_particles.emitting = true
	elif area.name == "damage_area":
		if Global_Variables.player_health > 0:
			#decrease health by 1:
			Global_Variables.player_health -= 1
			Audio_System.hurt_sfx.play()
			feedback.show_feedback("Health -1" , "r")
			blood_anim.frame = 0
			blood_anim.play()
	elif area.name == "laundry_area":
		var laundry = area.get_parent()
		var cloth_type: String = laundry.cloth_name
		var weight: int = area.get_parent().weight
		#check if there is enough carry capacity:
		if Global_Variables.get_total_carried_weight() + weight <= Global_Variables.carry_capacity:
			Global_Variables.carried_laundary.append(cloth_type)
			Global_Variables.carried_weight.append(weight)
			laundry.queue_free()
			Audio_System.laundry_pickup_sfx.play()
			feedback.show_feedback("Picked up " + cloth_type , "g")
		else: feedback.show_feedback("No room to carry more laundry!" , "r")
	elif area.name == "basket_area":
		var weight = Global_Variables.get_total_carried_weight()
		if(weight > 0):
			var reward = weight * Global_Variables.reward_per_weight
			Global_Variables.score += reward
			feedback.show_feedback("Reward +" + str(reward) , "g")
			Global_Variables.carried_laundary = []
			Global_Variables.carried_weight = []
			Audio_System.deliver_laundry_sfx.play()
		


