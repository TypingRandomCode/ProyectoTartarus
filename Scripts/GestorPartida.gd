extends Node

var escena_checkpoint: String = ""
var posicion_checkpoint: Vector2 = Vector2.ZERO
var tiene_checkpoint: bool = false
var trasladar_al_cargar: bool = false

## Registra un altar activado (o el inicio de la sala por defecto)
func registrar_altar(ruta_escena: String, posicion: Vector2) -> void:
	escena_checkpoint = ruta_escena
	posicion_checkpoint = posicion
	tiene_checkpoint = true
	print("Altar registrado en: ", ruta_escena, " pos: ", posicion)

## Define el inicio de la sala actual como checkpoint por defecto si aún no hay altar activo
func asegurar_checkpoint_inicial(ruta_escena: String, posicion_inicial: Vector2) -> void:
	if not tiene_checkpoint:
		escena_checkpoint = ruta_escena
		posicion_checkpoint = posicion_inicial
		tiene_checkpoint = true

## Reaparece al jugador de inmediato en el último altar y restaura sus 3 puntos de Fe
func reaparecer(jugador: CharacterBody2D) -> void:
	var escena_actual := jugador.get_tree().current_scene.scene_file_path

	# Si el altar está en esta misma sala: reaparición instantánea sin recargar
	if not tiene_checkpoint or escena_checkpoint == "" or escena_checkpoint == escena_actual:
		jugador.global_position = posicion_checkpoint
		jugador.velocity = Vector2.ZERO
		jugador.restaurar_fe()
	else:
		# Si murió en otra sala distinta a la del último altar: vuelve a la escena del altar
		trasladar_al_cargar = true
		jugador.get_tree().call_deferred("change_scene_to_file", escena_checkpoint)
