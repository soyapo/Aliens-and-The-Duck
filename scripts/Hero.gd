extends Area2D

signal hit # age be doshman barkhord kone emit mishe

var speed = 0 # base speed 0 e dige

func _process(delta):
	if Input.is_action_pressed("right"): # right = D
		speed = min(700, speed + 100) # be speed 100 ta ezafe kon vali az 700 bishtar nashe
	if Input.is_action_pressed("left"): # left = A
		speed = max(-700, speed - 100) # az speed 100 ta kam kon vali az -700 kamtar nashe
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		speed = 0 # voroodi ha ro vel kard user? negah dar charactero

	var diff = speed * delta # * delta baraye inke taht frame rate haye mokhtalef sabet bemoone speed

	if speed > 0: # speed mosbat = jahat raast
		position.x = min(position.x + diff, 520)
		# be position ofoghi character be andaze diff ezafe kon vali as 520 oonvar tar nare
		# 520: 550 (width safhe) - 30 (nesf width character) 
	elif speed < 0: # speed manfi = jahat chap
		position.x = max(position.x + diff, 30)
		# az position ofoghi character be andaze diff kam kon vali as 30 oonvar tar nare
		# 30: (nesf width character) (default nesfesh dakhele nesfesh biroon)

func _on_body_entered(_body): # kasi oomad too?
	emit_signal("hit") # signal hit raa emit benamaa 
