extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("_trigger_game_over"):
		body._trigger_game_over()#chama trigger_game_over 
