extends Area2D
@onready var ui = get_tree().current_scene.get_node("UI")

func _on_body_entered(body):
	body.die()
	ui.togglePause(true)
	queue_free()
