extends Area2D

@onready var luz: PointLight2D = $LuzAltar
var activado: bool = false

func _ready() -> void:
	body_entered.connect(_al_entrar_cuerpo)

func _al_entrar_cuerpo(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		activar_altar()
		# Opcional: también restaura la Fe al tocar el altar en vida
		if body.has_method("restaurar_fe"):
			body.restaurar_fe()

func activar_altar() -> void:
	var ruta_escena := get_tree().current_scene.scene_file_path
	GestorPartida.registrar_altar(ruta_escena, global_position)
	if not activado:
		activado = true
		if luz:
			var tween := create_tween()
			tween.tween_property(luz, "energy", 1.5, 0.3)
