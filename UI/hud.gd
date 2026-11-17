extends CanvasLayer
## HUD de Fe. No conoce al jugador: se conecta a su señal `fe_cambiada`.

@onready var esferas: Array[Control] = [
	$Margen/Fondo/Fila/Fe/Esfera1,
	$Margen/Fondo/Fila/Fe/Esfera2,
	$Margen/Fondo/Fila/Fe/Esfera3,
]

func conectar_jugador(jugador: Node) -> void:
	if not jugador.fe_cambiada.is_connected(actualizar_fe):
		jugador.fe_cambiada.connect(actualizar_fe)
	actualizar_fe(jugador.fe, jugador.fe_maxima)  # estado inicial: 3 llenas

func actualizar_fe(actual: int, _maximo: int) -> void:
	for i in esferas.size():
		esferas[i].llena = i < actual
