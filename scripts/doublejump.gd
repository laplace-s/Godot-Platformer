extends Area2D


func _on_body_entered(body):
	body.doublejump = true
	print("in double jump")
	queue_free()
