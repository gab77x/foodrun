extends Node2D

@export var item_scenes: Array[PackedScene] = []
@export var item_chance: float = 0.3
@export var gap_above_obstacle: float = 30.0

func _on_obstacle_spawned(obstacle: Node2D) -> void:
	if item_scenes.is_empty():
		return

	if randf() < item_chance:
		var collision_shape: CollisionShape2D = obstacle.get_node("CollisionShape2D")
		var shape_scale: Vector2 = collision_shape.scale
		var obstacle_height: float = collision_shape.shape.size.y * shape_scale.y * obstacle.scale.y

		# Centro real da colisão, considerando se o CollisionShape2D está deslocado do centro do obstáculo
		var shape_center_y: float = obstacle.global_position.y + (collision_shape.position.y * obstacle.scale.y)
		var top_of_obstacle: float = shape_center_y - (obstacle_height / 2.0)

		var item_scene: PackedScene = item_scenes[randi() % item_scenes.size()]
		var item: Node2D = item_scene.instantiate()
		item.global_position = Vector2(obstacle.global_position.x, top_of_obstacle - gap_above_obstacle)

		get_tree().current_scene.add_child(item)
