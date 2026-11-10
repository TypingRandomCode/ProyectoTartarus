extends Area2D

func _on_body_entered(body):
	# Verificamos si el objeto que acaba de tocar la trampa es el jugador
	if body.has_method("recibir_dano"):
		body.recibir_dano(1) # Resta 1 punto de Fe[cite: 4]
