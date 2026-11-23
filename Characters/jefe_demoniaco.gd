extends CharacterBody2D

signal jefe_derrotado

const GRAVITY = 980.0
const VELOCIDAD_EMBESTIDA = 450.0
const FUERZA_SALTO = -600.0

var vida_maxima: int = 10
var vida_actual: int = 10
var direccion: int = -1
var patron_actual: int = 0 # 0 = Embestida, 1 = Salto

@onready var anim = $AnimatedSprite2D
@onready var barra_vida = $HUDJefe/BarraVida

func _ready():
	barra_vida.max_value = vida_maxima
	barra_vida.value = vida_actual
	anim.play("default")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		velocity.x = move_toward(velocity.x, 0, 15.0)

	move_and_slide()
	
	# Cambia de dirección automáticamente al tocar una pared
	if is_on_wall():
		direccion *= -1
		anim.flip_h = (direccion > 0)

func _on_timer_ataque_timeout():
	if not is_on_floor():
		return
		
	if patron_actual == 0:
		ataque_embestida()
		patron_actual = 1
	else:
		ataque_salto()
		patron_actual = 0

func ataque_embestida():
	print("IA Jefe: Embestida")
	velocity.x = direccion * VELOCIDAD_EMBESTIDA

func ataque_salto():
	print("IA Jefe: Salto Demoníaco")
	velocity.y = FUERZA_SALTO
	velocity.x = direccion * (VELOCIDAD_EMBESTIDA * 0.6)

func _on_zona_dano_body_entered(body):
	if body.name == "Jugador" and body.has_method("recibir_dano"):
		body.recibir_dano(1)

func recibir_dano(cantidad: int):
	vida_actual -= cantidad
	barra_vida.value = vida_actual
	print("Vida restante del Jefe: ", vida_actual)
	
	anim.modulate = Color(1, 1, 1)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(0.6, 0.1, 0.3)
	
	if vida_actual <= 0:
		morir()

func morir():
	print("¡Jefe derrotado!")
	jefe_derrotado.emit()
	queue_free()
