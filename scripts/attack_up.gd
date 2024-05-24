extends Area2D

func _on_body_entered(body):
	body.attack = true
	queue_free()
