extends RigidBody2D

# age az safhe raft biroon naboodesh mikonim resource hamoon hadar nare
func _on_in_screen_screen_exited():
	queue_free()
