extends Node2D

@export_file("*.tscn") var siguiente_escena: String
## true = caer al abismo cuesta 1 de Fe; false = solo reaparece
@export var caer_cuesta_fe: bool = true

@onready var punto_respawn: Marker2D = $PuntoRespawn
@onready var zona_caida: Area2D = $Floor/ZonaCaida
@onready var salida_torii: Area2D = $SalidaTorii
@onready var hud: CanvasLayer = $HUD
@onready var jugador: CharacterBody2D = $Jugador

func _ready() -> void:
	zona_caida.body_entered.connect(_al_caer)
	salida_torii.body_entered.connect(_al_salir)
	hud.conectar_jugador(jugador)

func _al_caer(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	body.global_position = punto_respawn.global_position
	body.velocity = Vector2.ZERO
	if caer_cuesta_fe:
		body.recibir_dano()  # si llega a 0, morir() recarga la escena

func _al_salir(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	if siguiente_escena != "":
		get_tree().call_deferred("change_scene_to_file", siguiente_escena)
	else:
		get_tree().call_deferred("reload_current_scene")
