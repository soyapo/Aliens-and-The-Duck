extends RigidBody2D

# age az safhe raft biroon naboodesh mikonim resource hamoon hadar nare
func _on_in_screen_screen_exited():
	queue_free()
	
func _on_body_entered(body): # age chizi oomad too...
	if body.name != 'Hero': #...check kon character nabashe (doshman bashe)
		hide() # goloole ro hide kon
		body.hide() # doshman gerami ro hide kon
