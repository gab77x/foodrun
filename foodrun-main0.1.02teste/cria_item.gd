extends Node2D

@export var item_scenes: Array[PackedScene] = []
@export var item_chance: float = 0.4
@export var gap_above_obstacle: float = 30.0
@export var long_gap_item_chance: float = 0.5
@export var long_gap_item_height_above_ground: float = 120.0
@export var criaespinho: Node2D
@export var criachao: Node2D
@export var air_item_chance: float = 0.4
@export var air_item_height_above_ground: float = 150.0

func _ready() -> void:
	if criaespinho:
		criaespinho.spike_gap_found.connect(_on_spike_gap_found)
		criaespinho.long_gap_found.connect(_on_long_gap_found)

func _on_obstacle_spawned(obstacle: Node2D) -> void:
	if item_scenes.is_empty():
		return

	if randf() < item_chance:
		var collision_shape: CollisionShape2D = obstacle.get_node("CollisionShape2D")
		var shape_scale: Vector2 = collision_shape.scale
		var obstacle_height: float = collision_shape.shape.size.y * shape_scale.y * obstacle.scale.y

		var shape_center_y: float = obstacle.global_position.y + (collision_shape.position.y * obstacle.scale.y)
		var top_of_obstacle: float = shape_center_y - (obstacle_height / 2.0)

		var item_scene: PackedScene = item_scenes[randi() % item_scenes.size()]
		var item: Node2D = item_scene.instantiate()
		item.global_position = Vector2(obstacle.global_position.x, top_of_obstacle - gap_above_obstacle)

		get_tree().current_scene.add_child(item)

func _on_spike_gap_found(gap_center_x: float, gap_width: float) -> void:
	if item_scenes.is_empty():
		return

	if randf() < air_item_chance:
		var ground_y: float = criachao.ground_y if criachao else 570.0
		var item_scene: PackedScene = item_scenes[randi() % item_scenes.size()]
		var item: Node2D = item_scene.instantiate()
		item.global_position = Vector2(gap_center_x, ground_y - air_item_height_above_ground)
		get_tree().current_scene.add_child(item)

func _on_long_gap_found(item_x: float, gap_width: float) -> void:
	if item_scenes.is_empty():
		return

	if randf() < long_gap_item_chance:
		var ground_y: float = criachao.ground_y if criachao else 570.0
		var item_scene: PackedScene = item_scenes[randi() % item_scenes.size()]
		var item: Node2D = item_scene.instantiate()
		item.global_position = Vector2(item_x, ground_y - long_gap_item_height_above_ground)
		get_tree().current_scene.add_child(item)
