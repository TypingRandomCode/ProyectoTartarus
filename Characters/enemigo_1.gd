extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -320.0
const ATTACK_DISTANCE = 180.0
const DANO = 1                # daño que hace al jugador
const COOLDOWN_DANO = 1.0     # segundos entre golpes al jugador

var vida: int = 2             # muere con 2 golpes
var muerto: bool = false
var puede_danar: bool = true
var direction := 1.0
var player: Node2D = null

func _ready() -> void:
	add_to_group("enemigos")
	player = get_parent().get_node_or_null("Jugador")

func _physics_process(delta: float) -> void:
	if muerto:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if player != null:
		var distance_x: float = abs(player.global_position.x - global_position.x)
		direction = sign(player.global_position.x - global_position.x)
		if direction == 0.0:
			direction = 1.0

		if distance_x <= ATTACK_DISTANCE and is_on_floor():
			velocity.y = JUMP_VELOCITY

	velocity.x = direction * SPEED
	move_and_slide()

	# ---------- Atacar al jugador ----------
	if puede_danar:
		for body in $AreaAtaque.get_overlapping_bodies():
			if body.is_in_group("jugador"):
				puede_danar = false
				get_tree().create_timer(COOLDOWN_DANO).timeout.connect(func(): puede_danar = true)
				body.recibir_dano(DANO)   # al final: puede reiniciar la escena
				break

# ---------- Recibir daño ----------
func recibir_dano(cantidad: int = 1) -> void:
	if muerto:
		return
	vida -= cantidad
	if vida <= 0:
		morir()
	else:
		parpadear()

func parpadear() -> void:
	var tw := create_tween()
	for i in 3:
		tw.tween_property($Sprite2D, "modulate", Color(1, 0.3, 0.3, 0.4), 0.06)
		tw.tween_property($Sprite2D, "modulate", Color.WHITE, 0.06)

func morir() -> void:
	muerto = true
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	$AreaAtaque/CollisionShape2D.set_deferred("disabled", true)
	var tw := create_tween()
	tw.tween_property($Sprite2D, "modulate", Color(1, 0.3, 0.3, 0.0), 0.4)
	tw.tween_callback(queue_free)
