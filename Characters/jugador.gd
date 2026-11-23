extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const TIEMPO_INVULNERABLE = 0.8   # segundos sin recibir daño tras un golpe

var fe: int = 3                   # muere con 3 golpes
var atacando: bool = false
var invulnerable: bool = false
var muerto: bool = false
var enemigos_golpeados: Array = []
var anim_actual: String = ""
@onready var anim_player: AnimationPlayer = $AnimationPlayer
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$HitboxAtaque.body_entered.connect(_on_hitbox_ataque_body_entered)

func _physics_process(delta):
	if muerto:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("salto") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("ataque"):
		realizar_ataque()

	var direction = Input.get_axis("mover_izq", "mover_der")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			$Sprite2D.flip_h = false
			$HitboxAtaque.scale.x = 1
		elif direction < 0:
			$Sprite2D.flip_h = true
			$HitboxAtaque.scale.x = -1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	actualizar_animacion(direction)

# ---------- Animación de movimiento ----------
func actualizar_animacion(direction: float) -> void:
	if atacando:
		return
	var nueva := "walk" if (direction != 0.0 and is_on_floor()) else "RESET"
	if nueva != anim_actual:
		anim_actual = nueva
		anim_player.play(nueva)

# ---------- Recibir daño ----------
func recibir_dano(cantidad: int = 1):
	if invulnerable or muerto:
		return
	fe -= cantidad
	print("Fe restante: ", fe)
	if fe <= 0:
		morir()
	else:
		parpadear()

func parpadear() -> void:
	invulnerable = true
	var tw := create_tween()
	for i in 6:
		tw.tween_property($Sprite2D, "modulate", Color(1, 0.3, 0.3, 0.4), 0.06)
		tw.tween_property($Sprite2D, "modulate", Color.WHITE, 0.06)
	tw.tween_interval(max(TIEMPO_INVULNERABLE - 0.72, 0.0))
	tw.tween_callback(func(): invulnerable = false)

func morir() -> void:
	muerto = true
	print("El alma se ha perdido. Reapareciendo...")
	get_tree().reload_current_scene.call_deferred()

# ---------- Atacar ----------
func realizar_ataque() -> void:
	if atacando:
		return
	atacando = true
	enemigos_golpeados.clear()
	anim_actual = "attack"
	anim_player.play("attack")
	await anim_player.animation_finished
	anim_actual = ""   # fuerza a elegir walk/idle en el siguiente frame
	atacando = false

func _on_hitbox_ataque_body_entered(body: Node2D) -> void:
	# Solo golpea enemigos, y solo una vez por ataque
	if body.is_in_group("enemigos") and not enemigos_golpeados.has(body):
		enemigos_golpeados.append(body)
		body.recibir_dano(1)
