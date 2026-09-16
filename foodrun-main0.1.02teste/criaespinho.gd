extends Node2D

signal spike_spawned(pos_x: float)
signal spike_gap_found(gap_center_x: float, gap_width: float)
signal long_gap_found(item_x: float, gap_width: float)

@export var espinho_scene: PackedScene
@export var criachao: Node2D
@export var min_segments_for_spike: int = 3
@export var spike_chance: float = 0.5
@export var min_spawn_x: float = 900.0
@export var min_gap_for_item: float = 150.0
@export var max_gap_for_item: float = 500.0

var consecutive_segments: int = 0
var last_spike_x: float = -1.0

func _ready() -> void:
	criachao.ground_spawned.connect(_on_ground_spawned)

func _on_ground_spawned(spawn_position: Vector2, is_solid: bool) -> void:
	if not is_solid:
		consecutive_segments = 0
		return

	consecutive_segments += 1

	if criachao.pit_cooldown_segments > 0:
		return

	if spawn_position.x < min_spawn_x:
		return

	if consecutive_segments >= min_segments_for_spike and randf() < spike_chance:
		var espinho: Area2D = espinho_scene.instantiate()
		espinho.global_position = spawn_position
		get_tree().current_scene.add_child(espinho)
		spike_spawned.emit(spawn_position.x)
		if last_spike_x >= 0.0:
			var gap: float = spawn_position.x - last_spike_x
			if gap >= min_gap_for_item and gap <= max_gap_for_item:
				var gap_center: float = last_spike_x + (gap/ 2.0)
				spike_gap_found.emit(gap_center, gap)
			elif gap > max_gap_for_item:
					var margin: float = max_gap_for_item / 2.0
					var min_x: float = last_spike_x + margin
					var max_x: float = spawn_position.x - margin
					if max_x > min_x:
						var item_x: float = randf_range(min_x, max_x)
						long_gap_found.emit(item_x, gap)
		last_spike_x = spawn_position.x
		consecutive_segments = 0
