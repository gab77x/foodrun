extends Node2D

signal obstacle_spawned(obstacle: Node2D)

@export var obstacle_scenes: Array[PackedScene] = []
@export var player: CharacterBody2D
@export var gap_min: float = 380.0
@export var safety_margin: float = 0.40

var next_spawn_x: float = 800.0

func _get_max_jump_distance() -> float:
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var jump_speed: float = abs(player.JUMP_VELOCITY)
	var speed: float = player.SPEED
	var fall_multiplier: float = player.FALL_GRAVITY_MULTIPLIER

	var time_up: float = jump_speed / gravity
	var peak_height: float = (jump_speed * jump_speed) / (2.0 * gravity)
	var time_down: float = sqrt((2.0 * peak_height) / (gravity * fall_multiplier))

	var total_air_time: float = time_up + time_down
	return speed * total_air_time

func _process(_delta: float) -> void:
	if player.global_position.x + 1000 > next_spawn_x:
		spawn_obstacle()

func spawn_obstacle() -> void:
	if obstacle_scenes.is_empty():
		return
	var scene: PackedScene = obstacle_scenes[randi() % obstacle_scenes.size()]
	var obstacle: Node2D = scene.instantiate()
	obstacle.global_position = Vector2(next_spawn_x, 500)
	get_tree().current_scene.add_child(obstacle)
	obstacle_spawned.emit(obstacle)

	# Descobre a largura real do obstáculo através da colisão dele
	var collision_shape: CollisionShape2D = obstacle.get_node("CollisionShape2D")
	var obstacle_width: float = collision_shape.shape.size.x * obstacle.scale.x

	var max_gap: float = (_get_max_jump_distance() * safety_margin) - obstacle_width
	var gap: float = randf_range(gap_min, max(gap_min, max_gap))

	next_spawn_x = next_spawn_x + obstacle_width + gap
