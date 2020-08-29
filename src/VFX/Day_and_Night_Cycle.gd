extends CanvasModulate

var current_anim: String = ""
export var day_value: float = 1.0
export var night_value: float = 0.1
var _increment: float = 0

func _ready():
	Time_System.connect("day_to_night" , self , "play_day_to_night")
	Time_System.connect("night_to_day" , self , "play_night_to_day")

func _process(delta):
	if current_anim == "Day_to_Night":
		var anim_period_sec: float = Time_System.day_to_night_period / 1000.0
		var many_deltas: float = anim_period_sec / delta
		_increment = ((night_value - day_value) / many_deltas)
		color.r = max(color.r + _increment , night_value)
		color.g = max(color.g + _increment , night_value)
		color.b = max(color.b + _increment , night_value)
		if color.b <= night_value:
			current_anim = ""
	elif current_anim == "Night_to_Day":
		var anim_period_sec: float = Time_System.day_to_night_period / 1000.0
		var many_deltas: float = anim_period_sec / delta
		_increment = ((day_value - night_value) / many_deltas) 
		color.r = min(color.r + _increment , day_value)
		color.g = min(color.g + _increment , day_value)
		color.b = min(color.b + _increment , day_value)
		if color.b >= day_value:
			current_anim = ""

func play_day_to_night():
	current_anim = "Day_to_Night"

func play_night_to_day():
	current_anim = "Night_to_Day"
