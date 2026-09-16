extends Node2D

signal obstacle_spawned(obstacle: Node2D)

@export var obstacle_scenes: Array[PackedScene] = []
@export var obstacle_y: float = 500.0

func _on_pit_spawned(pit_start_x: float, pit_size: float) -> void:
	if obstacle_scenes.is_empty():
		return

	var scene: PackedScene = obstacle_scenes[randi() % obstacle_scenes.size()]
	var obstacle: Node2D = scene.instantiate()

	var pit_center_x: float = pit_start_x + (pit_size / 2.0)
	obstacle.global_position = Vector2(pit_center_x, obstacle_y)

	get_tree().current_scene.add_child(obstacle)
	obstacle_spawned.emit(obstacle)
