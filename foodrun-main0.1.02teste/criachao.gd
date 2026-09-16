extends Node2D

signal ground_spawned(position: Vector2, is_solid: bool)
signal pit_spawned(pit_start_x: float, pit_size: float)

@export var chao_scene: PackedScene
@export var player: CharacterBody2D
@export var obstaculos: Node2D   # <- novo: referência ao script de espinhos
@export var segment_width: float = 180.0
@export var pit_chance: float = 0.35
@export var safety_margin: float = 0.85
@export var ground_y: float = 570.0
@export var safe_start_distance: float = 600.0
@export var min_obstacle_width_estimate: float = 100.0

var next_x: float = 0.0
var pit_cooldown_segments: int = 0

func _ready() -> void:
	obstaculos.spike_spawned.connect(_on_spike_spawned)

func _on_spike_spawned(_pos_x: float) -> void:
	var required_gap: float = get_max_jump_distance() * safety_margin
	pit_cooldown_segments = ceili(required_gap / segment_width) + 1  # +1 de folga

func get_max_jump_distance() -> float:
	var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
	var jump_speed: float = abs(player.JUMP_VELOCITY)
	var speed: float = player.SPEED
	var fall_multiplier: float = player.FALL_GRAVITY_MULTIPLIER
	var time_up: float = jump_speed / gravity
	var peak_height: float = (jump_speed * jump_speed) / (2.0 * gravity)
	var time_down: float = sqrt((2.0 * peak_height) / (gravity * fall_multiplier))
	return speed * (time_up + time_down)

func _process(_delta: float) -> void:
	if player.global_position.x + 1200 > next_x:
		spawn_segment()

func spawn_segment() -> void:
	var max_safe_gap: float = get_max_jump_distance() * safety_margin
	var past_safe_zone: bool = next_x >= safe_start_distance
	var can_spawn_pit: bool = pit_cooldown_segments <= 0

	var min_pit_with_platform: float = (max_safe_gap * 0.6) * 2 + min_obstacle_width_estimate

	if past_safe_zone and can_spawn_pit and randf() < pit_chance and min_pit_with_platform <= (max_safe_gap * 2):
		var pit_size: float = randf_range(min_pit_with_platform, max_safe_gap * 1.9)
		ground_spawned.emit(Vector2(next_x, ground_y), false)
		pit_spawned.emit(next_x, pit_size)
		next_x += pit_size
	else:
		if pit_cooldown_segments > 0:
			pit_cooldown_segments -= 1
		var segment: StaticBody2D = chao_scene.instantiate()
		segment.global_position = Vector2(next_x + segment_width / 2.0, ground_y)
		get_tree().current_scene.add_child(segment)
		ground_spawned.emit(segment.global_position, true)
		next_x += segment_width
