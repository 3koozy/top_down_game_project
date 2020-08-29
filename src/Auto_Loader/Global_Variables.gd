extends Node

export var player_max_health: int = 10
var player_health: int = player_max_health
var score: int = 0
export var carry_capacity: int = 10
var carried_laundary: = []
var carried_weight: = []
export var reward_per_weight: int = 50

func get_total_carried_weight() -> int:
	var total = 0
	for i in range(carried_weight.size()):
		total += carried_weight[i]
	return total
