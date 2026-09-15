extends Node

var score: int = 0
var _distance_accumulator: float = 0.0
const PIXELS_PER_POINT: float = 100.0

func add_distance(pixels: float) -> void:
	_distance_accumulator += pixels
	while _distance_accumulator >= PIXELS_PER_POINT:
		_distance_accumulator -= PIXELS_PER_POINT
		score += 1

func add_item_score() -> void:
	score += 100

func reset_score() -> void:
	score = 0
	_distance_accumulator = 0.0
