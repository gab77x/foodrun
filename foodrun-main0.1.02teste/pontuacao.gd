extends Label

func _process(_delta: float) -> void:
	text = "Pontos: %d" % Global.score
