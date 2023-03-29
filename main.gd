extends Node

signal death

var wave_scene = load("res://Bullet.tscn")
var alien_scene = load("res://Alien.tscn")

var alien_pool = [1, 1, 1, 2, 2, 3]
var alpha_pos = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]
var alpha_chance = [0, 0, 0, 1]
var beta_pos = [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]]
var beta_chance = [0, 1]
var omega_pos = [[0], [3]]
var alien_size = [88, 64] # (1100, 800) * 0.08

var type
var alien
var velocity
var score = 0
var health = 5
	
func _ready():
	randomize()
	$HealthRate.frame = 5

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		send_wave()

func _on_menu_start():
	get_tree().call_group("not_in_menu", "show")
	$AlienTimer.start()
	$Menu.hide()
	
func send_wave():
	var wave = wave_scene.instantiate()
	add_child(wave)
	wave.position = $Hero.position
	$Hero/Quack.play()
	
func send_alien():
	type = alien_pool[randi() % alien_pool.size()]
	velocity = Vector2(0, randf_range(500, 700))
	await get_tree().create_timer(randf() * 0,5).timeout
	if type == 1:
		for i in alpha_pos[randi() % alpha_pos.size()]:
			setup_alien(i, velocity)
	elif type == 2:
		for i in beta_pos[randi() % beta_pos.size()]:
			setup_alien(i, velocity)
	elif type == 3:
		for i in omega_pos[randi() % omega_pos.size()]:
			if i == 3:
				velocity.x = -260 
			else:
				velocity.x = 260
			setup_alien(i, velocity)
	$AlienTimer.start()

func setup_alien(i, v):
	alien = alien_scene.instantiate()
	add_child(alien)
	alien.position.x = (i * 126) + 38 + 44
	alien.position.y = -32
	alien.linear_velocity = v

func _on_alien_timer_timeout():
	send_alien()
	score += 1
	$Score.text = str(score)

func _on_hero_hit():
	$Hero/Quack.play()
	$HealthRate.frame -= 1
	if $HealthRate.frame == 0:
		emit_signal("death")

func _on_death():
	$AlienTimer.stop()
	$Hero/Hero_Texture.animation = "death"
	for i in range(0, 7):
		$Hero/Hero_Texture.frame = i
		await get_tree().create_timer(0.1).timeout
	$Hero.hide()
