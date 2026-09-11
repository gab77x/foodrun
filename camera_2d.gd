extends Camera2D
var fixed_y: float

func _ready() -> void:
	fixed_y = global_position.y
	
func _process(delta: float) -> void:
	global_position.y = fixed_y
