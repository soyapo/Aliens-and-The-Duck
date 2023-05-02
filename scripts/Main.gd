extends Node

signal death # signali ke bad az marg emit mishe

var bullet_scene = load("res://scenes/Bullet.tscn")
var alien_scene = load("res://scenes/Alien.tscn")

# type 1 (alpha) => radif 2 taei doshamn
# type 2 (beta) => radif 3 taei doshman
# type 3 (omega) => radif taki doshman baa harekat movarrab
  
# ehtemal oomadan type haye mokhtalef dar ->
# easy mode: 1 => 1/2 - 2 => 1/3 - 3 => 1/6 
var alien_pool_easy = [1, 1, 1, 2, 2, 3]
# hard mode: 1 => 0 - 2 => 3/4 - 3 => 1/4 
var alien_pool_hard = [2, 2, 2, 3]

# position haye type alpha doshman o goloole, ba ehtemal 1/6 baraye vojood goloole 
var alpha_pos = [[0, 1], [0, 2], [0, 3], [1, 2], [1, 3], [2, 3]]
# positione haye type beta doshman o goloole, ba ehtemal 1/4 baraye vojood goloole 
var beta_pos = [[0, 1, 2], [0, 1, 3], [0, 2, 3], [1, 2, 3]]
# positione type omega doshman (goloole = 3 - doshman), ba ehtemal 1/2 baraye vojood goloole 
var omega_pos = [[0], [3]]

var type # che type doshmani befrestam? (meghdar random az list alien_pool)
var alien # nemoone doshman baraye instantiate
var bullet # nemoone goloole baraye instantiate

var bullet_count = 0 # cheghadr goloole darim?
var score = 0 # emtiazemoon chande?
var health = 5 # cheghadr joon darim?
var sound = 1 # background music dashte bashim? (boolean tori)
var quack = 1 # sedaye character dar biad? (boolean tori)
var easy # easy ya hard? (boolean tori)

var velocity # velocity ke meghdaresh randome (too range in dota paeenia)
var min_v # min velocity (700 bara hard)
var max_v # max velocity (900 bara hard)
var random_wait # yekam bishtar be meghdar random kesh midim porose goloole daadano
	
func _ready():
	randomize() # ke har dafe yekam motafavet bashe

func _process(_delta):
	if bullet_count and Input.is_action_just_pressed("attack"): # attack -> Enter
		send_bullet() # goloole bezan age dari (line 78)


func start(): # shoroo bazi
	bullet_count = 0 # tir ke nadarim avvalesh
	score = 0 # emtiaz ham hamintor
	health = 5 # joonemon pore vali
	$Hero.show() # character asli (ordak) ro neshoon bede
	$Menu.hide() # vasat bazi ke menu nemikhaym dige
	$AlienTimer.start() # age time out she doshman o goloole generate mikonim
	$BulletTimer.start() # age timeout she ye time random beyn 4 taa 8 saani sabr mikonim o ye goloole midim
	$HealthRate.frame = 5 # por neshoon bede health bar ro
	$BulletCount.text = '0' # meghdaresh reset she
	$Hero.position.x = 275 # reset she position esh
	$Hero/Hero_Texture.play("jog") # animation raah raftan ro neshoon bede
	get_tree().call_group("not_in_menu", "show") # health bar - character - emtiaz - ...
	
func _on_death_start_over(): # az avval?
	$Death.hide() # menu baakht ro hide kon
	$Menu.show() # menu asli ro neshoon bede
	$Menu/Start.hide() # dokme haye easy/hard ke joz menu an ro hide mikonim, ghabl shoroo oona moonde boodan
	get_tree().call_group("handling_buttons", "show") # gorooh dokme haye asli + title ro neshoon bede

func _on_menu_easy(): # sharayet easy
	easy = 1 # easy ro 1 mikonim, jelotar estefade mishe
	min_v = 500 # min velocity kam baraye noob haa
	max_v = 700 # max velocity kam varaye noob haa
	$BulletTimer.wait_time = 4 # too baze (4,8) sec ye goloole migirim
	random_wait = 4
	start() # shorooooooo (line 57)
	
func _on_menu_hard():
	easy = 0 # easy ro 0 mikonim, jelotar estefade mishe
	min_v = 700 # min velocity hanoozam kam baraye noob ha, kollan bazi asoone 
	max_v = 900 # hamoon aash o hamoon kaase
	$BulletTimer.wait_time = 6 # too baze (6, 12) sec ye goloole migirim
	random_wait = 6
	start() # shorooooooo (line 57)

func _on_bullet_timer_timeout():
	get_tree().create_timer(randi() % random_wait)
	bullet_count += 1 # az tedadesh yedoona kam mikonim
	$BulletCount.text = str(bullet_count) # tedad jadido string kon bede be counter esh roo safhe
	$BulletTimer.start()

func send_bullet():
	bullet = bullet_scene.instantiate() # nemoone misazim az goloole (line 5)
	add_child(bullet) # be onvan bache sarparastish ro midim be main
	bullet.gravity_scale = -5 # shetabdar mire bala injoori, doshman karesh sakht mishe
	bullet.position = $Hero.position # position shoroo esh ham az khod character e 
	if quack: # age user ejaze sedaye chrachter ro dade...
		$Hero/Quack.play() #...quack mikonim
	bullet_count -= 1 # az tedadesh yedoona kam mikonim
	$BulletCount.text = str(bullet_count) # tedad jadido string kon bede be counter esh roo safhe

func send_alien():
	await get_tree().create_timer(randf() * 0,5).timeout # ye time beyn 0 taa 0.5 sania sabr kon (randf beyn sefr o yek mide, nesfesh mikonim)
	velocity = Vector2(0, randf_range(min_v, max_v)) # sor'ateshoon amoodi o beyn min o max e (line 76-7, 82-3)
	
	if easy: # ghabltar meghdar dadim
		type = alien_pool_easy[randi() % alien_pool_easy.size()] # ehtemalan shaamel type 1 beshe
	else:
		type = alien_pool_hard[randi() % alien_pool_hard.size()] # faghat type 2 o 3
	
	if type == 1 and easy: # type 1? game easy? 
		for i in alpha_pos[randi() % alpha_pos.size()]: # kodoom jaayghasht ro begirim? (line 19) -> be ezaaye tamaam index haaye tooye list jaayghasht
			setup_alien(i, velocity) # alien befrest (line 150)
	elif type == 2: # 3 taei
		for i in beta_pos[randi() % beta_pos.size()]: # kodoom jaayghasht ro begirim? (line 24) -> be ezaaye tamaam index haaye tooye list jaayghasht
			setup_alien(i, velocity) # alien befrest (line 150)
	elif type == 3: # taki movarrab
		for i in omega_pos[randi() % omega_pos.size()]: # kodoom jaayghasht ro begirim? (line 29) -> be ezaaye tamaam index haaye tooye list jaayghasht
			if i == 3: # tak samt raaste?
				velocity.x = -260 # biaad be chap pas
			else: # chape?
				velocity.x = 260 # biaad raast
			setup_alien(i, velocity) # alien befrest (line 150)
	$AlienTimer.start() # alien_timer ro start kon dobare o dobare inaa bian

func setup_alien(i, v): # i: index - v: velocity
	alien = alien_scene.instantiate() # ye nemoone azash misaazim
	add_child(alien) # sarparastish ro be onvaan bache midim be main
	alien.position = Vector2((i * 126) + 38 + 44, -32) # mohaasebaat sangin bood :)) 38 fasele beineshoone 44 ham nesf arz esh 
	alien.linear_velocity = v # sor'at khatti behesh bede bi shetaab biad

func _on_alien_timer_timeout(): # 1 sanie gozasht... omr geraan migozarad, khaahi nakhaahi
	send_alien() # doshman befrest
	score += 1 # score ro yekam ziad kon
	$Score.text = str(score) # meghdaar jadidesho neshoon bede

func _on_hero_hit(): # be doshman barkhord kardim ghorbaan
	if quack: # user ejaze quack daade?
		$Hero/Quack.play() # quack kon
	$HealthRate.frame -= 1 # ye frame agahb tar (ke ye khoone khaali tar daare) ro neshoon bede
	if not $HealthRate.frame: # 0 shod?
		emit_signal("death") # mordim. haalaa be baghie begoo

func _on_death(): # mordim :(
	$AlienTimer.stop() # timer ro negah daar alien spawn nashe dige
	$BulletTimer.stop()
	$Death/DeathMenu/Death_Label.text = "You     Died!\n\n\nFinal Score: " + str(score) # meghdaar score + bonus ro be menu baakht ezafe kon
	get_tree().call_group("aliens", "queue_free") # alien haa ro nabood kon (hamashoon nemoone yekian va oon yeki too group aliens boode pas hamashoon hastan)
	get_tree().call_group("not_in_menu", "hide") # anaasori mesl maah, health bar, score,...
	$Hero.show() # character ro ye lahze neshoon bede kaar daarim
	$Hero/Hero_Texture.animation = "death" # animation esh ro bokon death
	$Hero/Hero_Texture.stop() # negah dar dasti taghir bedam frame haa ro
	for i in range(0, 7): #frame haye 1 taa 6...
		$Hero/Hero_Texture.frame = i #...ro set kon
		await get_tree().create_timer(0.1).timeout # 0.1 sanie sabr kon
	$Hero.hide() # dige mord. ghaayemesh kon.
	$Death.show() # menu baakht ro neshoon bede

func _on_menu_sound_change(): # be signal sound_change vasle ke baa dokme sound too options control mishe
	sound = 1 - sound # 1 -> 0 | 0 -> 1
	if sound: # 1?
		$bg_theme.play() # play kon 
	else: # 0?
		$bg_theme.stop() # estop

func _on_menu_quack_change():
	quack = 1 - quack # 1 -> 0 | 0 -> 1
