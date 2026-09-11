extends Node

var score: int = 0
var _distance_accumulator: float = 0.0
const PIXELS_PER_POINT: float = 100.0  # a cada 1px andados, +1 ponto

func add_distance(pixels: float) -> void:
	_distance_accumulator += pixels
	while _distance_accumulator >= PIXELS_PER_POINT:
		_distance_accumulator -= PIXELS_PER_POINT
		score += 1
		
func add_item_score() -> void:
	score += 100
