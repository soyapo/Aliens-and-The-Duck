extends RigidBody2D


func _on_in_screen_screen_exited():
	queue_free()
