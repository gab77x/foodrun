extends Button

func _on_pressed() -> void:
	get_tree().paused = false
	Global.reset_score()
	get_tree().reload_current_scene()
