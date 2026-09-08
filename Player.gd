extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -600.0
const FALL_GRAVITY_MULTIPLIER = 3  #esse valor controla quão rápido o personagem cai após o pulo
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
