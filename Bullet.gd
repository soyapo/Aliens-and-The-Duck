extends RigidBody2D

func _on_in_screen_screen_exited():
	queue_free()
	
func _on_body_entered(body:Node):
	if body.name != 'Hero':
		hide()
		body.hide()
		

