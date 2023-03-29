extends RigidBody2D

var min_speed = 500
var max_speed = 700

func _on_in_screen_screen_exited():
	queue_free()
