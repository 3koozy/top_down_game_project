extends Node

export var cloth_name: String = "cloth"
export var weight: int = 1


func _on_laundry_area_area_entered(area):
	if area.name == "player_area":
		queue_free()
