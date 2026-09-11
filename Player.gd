extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -650.0
const FALL_GRAVITY_MULTIPLIER = 3  #esse valor controla quão rápido o personagem cai após o pulo
const VOID_Y_LIMIT = 900.0  # ajuste esse valor conforme necessário

func _ready():
	$personagem.play("default")

func _physics_process(delta: float) -> void:
	# Adiciona a gravidade se não estiver no chão
	if not is_on_floor():
		if velocity.y > 0:
			# Está caindo: aplica gravidade mais forte
			velocity += get_gravity() * FALL_GRAVITY_MULTIPLIER * delta
		else:
			# Está subindo: gravidade normal
			velocity += get_gravity() * delta

	# Movimento automático em linha reta (para a direita)
	velocity.x = SPEED

	# Condição de pulo: aceita "Espaço", "Seta para Cima" ou "W"
	if is_on_floor() and (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_UP) or Input.is_key_pressed(KEY_W)):
		velocity.y = JUMP_VELOCITY

	move_and_slide()

	Global.add_distance(velocity.x * delta)

	if is_on_wall():
		$personagem.stop()
	else:
		if not $personagem.is_playing():
			$personagem.play("default")

	# Verifica se caiu no void
	if global_position.y > VOID_Y_LIMIT:
		_trigger_game_over()

func _trigger_game_over() -> void:
	set_physics_process(false)
	get_tree().paused = true
	get_node("/root/Game/gameoverlayer/telagameover").visible = true
