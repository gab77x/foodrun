extends Node2D

@export var obstacle_scenes: Array[PackedScene] = []
@export var player: CharacterBody2D
@export var spawn_distance_min: float = 300.0
@export var spawn_distance_max: float = 600.0

var next_spawn_x: float = 800.0

func _process(_delta: float) -> void:
	if player.global_position.x + 1000 > next_spawn_x:
		spawn_obstacle()

func spawn_obstacle() -> void:
	if obstacle_scenes.is_empty():
		return

	var scene: PackedScene = obstacle_scenes[randi() % obstacle_scenes.size()]
	var obstacle: Node2D = scene.instantiate()

	obstacle.global_position = Vector2(next_spawn_x, 500) # ajuste o Y pro seu chão

	get_tree().current_scene.add_child(obstacle)

	next_spawn_x += randf_range(spawn_distance_min, spawn_distance_max)
