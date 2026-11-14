extends Node2D

@export_file("*.tscn") var siguiente_escena: String

@onready var punto_respawn: Marker2D = $PuntoRespawn
@onready var zona_caida: Area2D = $Floor/ZonaCaida
@onready var salida_torii: Area2D = $SalidaTorii

func _ready() -> void:
	zona_caida.body_entered.connect(_al_caer)
	salida_torii.body_entered.connect(_al_salir)

func _al_caer(body: Node2D) -> void:
	print("Cayó: ", body.name, " | grupos: ", body.get_groups())
	if body.is_in_group("jugador") or body.name == "Jugador":
		body.global_position = punto_respawn.global_position
		if "velocity" in body:
			body.velocity = Vector2.ZERO

func _al_salir(body: Node2D) -> void:
	if body.is_in_group("jugador") or body.name == "Jugador":
		print("¡Cruzaste el Torii! Cambio de escena funcionando.")
		if siguiente_escena != "":
			get_tree().call_deferred("change_scene_to_file", siguiente_escena)
		else:
			get_tree().call_deferred("reload_current_scene")
