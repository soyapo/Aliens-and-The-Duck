extends Node

var wave_scene = load("res://wave.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		send_wave()
		quack()
		
func send_wave():
	var wave = wave_scene.instantiate()
	add_child(wave)
	wave.position.x = $Hero.position.x
	wave.position.y = $Hero.position.y

func quack():
	$Hero/quack.play()
