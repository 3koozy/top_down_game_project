extends Node

#signals:
signal day_to_night
signal night_to_day
#variables:
onready var time_of_day_signal_timer: Timer = get_node("time_of_day_signal_timer")
var running: bool = false
var refernece_time: float = 0 #msec
var current_time: float = -1 #msec
var time_of_day: String = "day"
const day_start_time: float = 0.0 #msec
export var day_period: float = 5000 #msec
export var day_to_night_period: float = 5000 #msec
export var night_period: float = 5000 #msec
export var night_to_day_period: float = 5000 #msec

func start_system():
	running = true
	refernece_time = OS.get_ticks_msec()
	time_of_day_signal_timer.start()

func _process(delta):
	if running:
		#get current time:
		var new_time = OS.get_ticks_msec()
		#check if paused:
		if new_time - current_time > 1000 and current_time != -1: #paused
			var actual_time_passed = current_time - refernece_time
			refernece_time = new_time - actual_time_passed
		current_time = new_time
		
		#check point : did we finish full day?
		if current_time-refernece_time >= get_full_day_period_msec():
			#update time reference point
			refernece_time = current_time

func get_game_time_24h() -> float:
	var time: float = (get_local_time_msec() / get_full_day_period_msec()) * 24.0
	time = time + 6 #offset
	if time > 24.0 :
		time = time - 24.0
	return time

func get_local_time_msec() -> float:
	return current_time - refernece_time

func _get_time_of_day() -> String:
	var local_time = get_local_time_msec()
	var day_end = day_period
	var day_to_night_end = day_end + day_to_night_period
	var night_end = day_to_night_end + night_period
	var night_to_day_end = night_end + night_to_day_period
	
	if local_time >= 0 and local_time < day_end : 
		return "day"
	elif local_time >= day_end and local_time < day_to_night_end:
		return "day_to_night"
	elif local_time >= day_to_night_end and local_time < night_end:
		return "night"
	else: return "night_to_day"

func get_full_day_period_msec() -> float:
	return day_period + day_to_night_period + night_period + night_to_day_period


func _on_time_of_day_signal_timer_timeout():
	var new_tod = _get_time_of_day()
	if new_tod != time_of_day: #time of day changed
		time_of_day = new_tod
		match time_of_day:
			"day_to_night": emit_signal("day_to_night")
			"night_to_day": emit_signal("night_to_day")
