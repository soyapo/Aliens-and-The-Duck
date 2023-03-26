extends RigidBody2D

var speed = 0

func _ready():
	$Hero_Texture.play("jog")

func _process(delta):
	if Input.is_action_pressed("right"):
		speed = min(400, speed + 80)
	if Input.is_action_pressed("left"):
		speed = max(-400, speed - 80)
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		speed = 0
		
	var diff = speed * delta

	if speed > 0:	
		position.x = min(position.x + diff, 520) # 550 - 30
	elif speed < 0:
		position.x = max(position.x + diff, 30)
