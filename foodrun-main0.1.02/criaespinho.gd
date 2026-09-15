extends Node2D

@export var espinho_scene: PackedScene
@export var criachao: Node2D
@export var min_segments_for_spike: int = 3
@export var spike_chance: float = 0.5
@export var min_spawn_x: float = 900.0

var consecutive_segments: int = 0

func _ready() -> void:
	criachao.ground_spawned.connect(_on_ground_spawned)

func _on_ground_spawned(position: Vector2, is_solid: bool) -> void:
	if not is_solid:
		consecutive_segments = 0
		return

	consecutive_segments += 1
	if position.x < min_spawn_x:
		return
	if consecutive_segments >= min_segments_for_spike and randf() < spike_chance:
		var espinho: Area2D = espinho_scene.instantiate()
		espinho.global_position = position
		get_tree().current_scene.add_child(espinho)
		consecutive_segments = 0
#gera espaçamento (ñ deixa um nascer colado/próximo a outro)
