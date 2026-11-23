extends Control
## Esfera de luz sagrada (1 punto de Fe). Dibujo provisional con círculos.

var llena := true:
	set(valor):
		llena = valor
		queue_redraw()

func _draw() -> void:
	var centro := size / 2.0
	var lado := minf(size.x, size.y)
	var radio := lado * 0.30
	if llena:
		# Halo suave (varios círculos con alfa decreciente)
		for i in 6:
			var t := float(i) / 5.0
			draw_circle(centro, lado * (0.46 - 0.12 * t), Color(1.0, 0.84, 0.5, 0.05 + 0.04 * t))
		draw_circle(centro, radio, Color("ffe9a8"))
		draw_circle(centro - Vector2(lado, lado) * 0.04, radio * 0.55, Color("fffae1"))
		draw_arc(centro, radio, 0.0, TAU, 40, Color("fff6d8"), 2.0, true)
	else:
		draw_circle(centro, radio, Color(0.07, 0.07, 0.09, 0.75))
		draw_arc(centro, radio, 0.0, TAU, 40, Color("4a4650"), 2.0, true)
