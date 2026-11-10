extends CharacterBody2D

# Variables de movimiento
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Sistema de vida
var fe: int = 3 # 3 puntos de Fe/Alma[cite: 4]
@onready var colision_ataque = $HitboxAtaque/CollisionShape2D

# Obtener la gravedad global de la configuración del proyecto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Añadir la gravedad si no está en el suelo
	if not is_on_floor():
		velocity.y += gravity * delta

	# Lógica de salto[cite: 4]
	if Input.is_action_just_pressed("salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Lógica de ataque cuerpo a cuerpo[cite: 4]
	if Input.is_action_just_pressed("ataque"):
		realizar_ataque()

	# Movimiento lateral
	var direction = Input.get_axis("mover_izq", "mover_der")
	if direction:
		velocity.x = direction * SPEED
		
		# Voltear el personaje y el ataque según la dirección
		if direction > 0: # Mirando a la derecha
			$Sprite2D.flip_h = false
			$HitboxAtaque.scale.x = 1
		elif direction < 0: # Mirando a la izquierda
			$Sprite2D.flip_h = true
			$HitboxAtaque.scale.x = -1
	else:
		# Fricción para detenerse
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

# Función para ser llamada cuando un enemigo, proyectil o lava lo toque
func recibir_dano(cantidad: int = 1):
	fe -= cantidad
	print("Fe restante: ", fe) # Log temporal para consola
	
	if fe <= 0:
		morir()

func morir():
	print("El alma se ha perdido. Reapareciendo...")
	# Reaparición inmediata reiniciando la escena actual[cite: 2]
	get_tree().reload_current_scene()

func realizar_ataque():
	print("¡Ataque de cadenas espirituales!")
	colision_ataque.disabled = false # Activa el daño
	
	# Espera 0.2 segundos (la duración del golpe) y lo desactiva
	await get_tree().create_timer(0.2).timeout
	colision_ataque.disabled = true
