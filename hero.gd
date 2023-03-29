extends Area2D

signal hit

var speed = 0

func _ready():
	$Hero_Texture.play("jog")

func _process(delta):
	if Input.is_action_pressed("right"):
		speed = min(700, speed + 100)
	if Input.is_action_pressed("left"):
		speed = max(-700, speed - 100)
	if Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		speed = 0
		
	var diff = speed * delta

	if speed > 0:	
		position.x = min(position.x + diff, 520) # 550 - 30
	elif speed < 0:
		position.x = max(position.x + diff, 30)

func _on_body_entered(body:RigidBody2D):
	emit_signal("hit")
	
	
