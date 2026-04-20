extends CharacterBody2D

#Player state
var player_alive = true
var max_health = 100
var health = 100
#==========================

#Items
var has_crystal_1 := false
var has_crystal_2 := false
var has_crystal_3 := false
var has_crystal_4 := false
var has_key := false
var health_potions: int = 0
var damage_potions: int = 0
#===============================

#Sounds
@onready var return_by_death_2 = $sound/return_by_death_2
@onready var return_by_death_1 = $sound/return_by_death_1
@onready var sword = $sound/sword
@onready var death = $sound/death
@onready var dodging = $sound/dodge
@onready var healthbar = $Healthbar
#=================================================

#Player attack/dodge/movement: values
const DODGE_TIME := 0.2
var attack_cooldown := 0.3
var ATTACK_1_DAMAGE := 18
var ATTACK_2_DAMAGE := 28
var speed = 170
var current_dir = "none"
var current_attack_damage := 0
var is_dodging := false
var is_attacking := false
var is_moving := false
var can_attack := true
#========================================

#Grejer som ska startas i början av scenen
func _ready():
	#Väntar en frame så att scenen hinner laddas klart
	await get_tree().process_frame
	
	#Ändrar dialogue om man redan dog och spelar respawn sound
	if global.just_died:
		$Fade_transition.show()
		$Fade_transition/AnimationPlayer.play("death")
		return_by_death_1.play()
		return_by_death_2.play()
		
		global_position = global.spawn_position #Ändrar position till spawn positionen
		global.changed_dialogue = true
		global.just_died = false
		
	else:
		if global.return_position != Vector2.ZERO:
			global_position = global.return_position #Gör så att man kan återvända till utanför slottet om man varit inuti det
		
	add_to_group("player") #Lägger till player i sin grupp
	$AnimatedSprite2D.play("Idle_up") #Spelar idle animation för spelaren
	
	healthbar.init_health(health) #Initierar healtbaren

#Nyckel upplockning
func pickup_key():
	has_key = true #Player har nyckelln i sitt förråd
	print("Player now has key:", has_key)

#Alla functions för att plocka upp kristallerna 
func pickup_crystal_1():
	has_crystal_1 = true
	print("Player now has Crystal:1")
func pickup_crystal_2():
	has_crystal_2 = true
	print("Player now has Crystal:2")
func pickup_crystal_3():
	has_crystal_3 = true
	print("Player now has Crystal:3")
func pickup_crystal_4():
	has_crystal_4 = true
	print("Player now has Crystal:4")

#Använding av nyckeln
func use_key() -> bool:
	if has_key:
		has_key = false #Nyckel förbrukas
		return true
	return false

#Saker som ska anropas konstat
func _physics_process(delta):
	if is_attacking: #Gör så att man kan attackera och röra på sig
		move_and_slide()
		return 
		
	if not can_attack:
		attack_cooldown -= delta #Timern
		if attack_cooldown <= 0: #När timern blir 0 kan man attackera igen
			can_attack = true
			
	player_movement(delta) #Spelarens movement anropas
	
	beat_the_games() #Kraven för att klara spelet

#Spelarens movement
func player_movement(delta):
	is_moving = false #Moving status börjar falsk
	
	if Input.is_action_pressed("Right"): #Om man trycker på d
		current_dir = "right" #Riktning blir höger
		play_anim(1) #Spela movement animatoin
		velocity.x = speed #Fart i x-led blir speed
		velocity.y = 0 #Fart i y-led är 0
		is_moving = true #Moving status blir sann
	elif Input.is_action_pressed("Left"): #Samma som saken ovanför fast för vänster
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
		is_moving = true
	elif Input.is_action_pressed("Down"): #Samma som saken ovanför fast för nedåt
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
		is_moving = true
	elif Input.is_action_pressed("Up"): #Samma som saken ovanför fast uppåt
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
		is_moving = true
	else: #Om man inte rör sig 
		play_anim(0) #Spela idle animation
		velocity.x = 0 #x-led fart är 0
		velocity.y = 0 #y-led fart är 0
		is_moving = false #Moving status är falsk
	
	move_and_slide() #Rör på spelare
	
#Animationer för movement
func play_anim(movement):
		
	var dir = current_dir #Riktning är nuvarande riktning
	var anim = $AnimatedSprite2D #Anim är animatedsprite2D
	
	if dir == "right": #Om riktning höger
		if movement == 1: #Om man rör sig
				anim.play("Run_right") #Spela run right animation
			
		elif movement == 0: #Om man inte rör sig
				anim.play("Idle_right") #Spela idle right animation
				
	elif dir == "left": #Om riktning vänster
		if movement == 1: #Om man rör sig
			anim.play("Run_left") #Spela run left animation
		elif movement == 0: #Om man inte rör sig
			anim.play("Idle_left")	 #Spela idle vänster animation
	elif dir == "down": #Om riktning ner
		if movement == 1: #Om man rör sig
			anim.play("Run_down") #Spela run down animation
		elif movement == 0: #Om man inte rör sig
			anim.play("Idle_down")	 #Spela idle down animation
	elif dir == "up": #Om riktning up
		if movement == 1: #Om man rör sig
			anim.play("Run_up") #Spela run up animation
		elif movement == 0: #Om man inte rör sig
			anim.play("Idle_up") #Spela idle up animation

#Attack function
func attack():
	
	if is_attacking:
		return

	is_attacking = true #Attack status blir aktiv
		
	var attack_name := "" 
	var bodies = $Player_hitbox.get_overlapping_bodies() #Sök för overlapping kroppar
	
	if is_moving: #Om man rör på sig blir attackname Attack2
		attack_name = "Attack_2"
		current_attack_damage = ATTACK_2_DAMAGE #Attack damage blir den som attack2 har
	else: #Om man inte rör sig blir det Attack1
		attack_name = "Attack_1"
		current_attack_damage = ATTACK_1_DAMAGE #Attack damage blir den som attack1 har
	
	for body in bodies:
		if body is Enemy or Boss_Enemy: #Om kropp är enemy eller boss enemy så ska dem ta skadan som den nuvarande attacken gör
			body.take_damage(current_attack_damage)
		else:
			pass
			
	match current_dir: #Matchar nuvarade riktningen med den animation som ska spelas
		"right":
			$AnimatedSprite2D.play(attack_name + "_right")
		"left":
			$AnimatedSprite2D.play(attack_name + "_left")
		"up":
			$AnimatedSprite2D.play(attack_name + "_up")
		"down":
			$AnimatedSprite2D.play(attack_name + "_down")
	sword.play() #Spela svärd ljudet
	await $AnimatedSprite2D.animation_finished #Vänta tills attack animation är klar

	is_attacking = false #Attackerar är falskt
	play_anim(0) #Spela idle

func take_damage(amount: int) -> void:
	if is_dodging: #Om man dodgar så kan man inte anropa funktionen medans den är igång
		return

	health -= amount #Health är lika det man hade minus det man förlorar
	print("Player HP:", health)
	if health <= 0: #Om player har noll health
		$AnimatedSprite2D.modulate = Color(0.66, 0.0, 0.0, 1) #Player blir röd
		die() #Anropa die funktionen
		return #Stoppar funktion
	healthbar.health = health #Healthbar = health

func heal(amount):
	health = min(health + amount, max_health)
	healthbar.health = health #Healthbar visar de health man har
	print("Healed! Current health:", health)
	
func use_health_potion():
	if health_potions > 0: #Om man har healthpotions i inventory
		health_potions -= 1 #Förbruka healtpotion
		heal(30) #Heala 30hp
		print("Used potion! Left:", health_potions)
	else:
		print("No potions!")

func damage_buff(amount):
	ATTACK_1_DAMAGE = ATTACK_1_DAMAGE + 15 #Buffar damage
	ATTACK_2_DAMAGE = ATTACK_2_DAMAGE + 15 #Buffar damage
	speed = min(speed + amount, 800) #Buffar din speed
	print("You're buffed! Current speed:", speed)
	print("You're buffed! Current normal damage:", ATTACK_1_DAMAGE)

func use_damage_potion():
	if damage_potions > 0: #Om du har damage potions (
		damage_potions -=1 #Förbruka potion
		damage_buff(300) #Buffa speed med 300
		print("Used potion! Left:", damage_potions)

func add_item(item_name: String):
	if item_name == "health_potion": #Om item man plockar upp heter health potion lägg till 1 i inventory
		health_potions += 1
		print("Picked up potion! Total:", health_potions)
	elif item_name == "damage_potion": #Om item man plockar upp heter damage potion lägg till 1 i inventory
		damage_potions += 1
		print("Picked up potion! Total:", damage_potions)
	elif item_name == "gold": #Om det heter guld lägg till 1 i inventory
		print("Got item:", item_name) #Så man ser vad man fick (I koden) händer

func die():
	player_alive = false #Player är inte vid liv
	print("player has been killed")
	
	$AnimationPlayer.play("death") #Spela death animation
	death.play() #Spela death sound
	
	await $AnimationPlayer.animation_finished #Vänta på att animation är klar
	global.just_died = true #Player dog precis är sant
	if get_tree():
		get_tree().reload_current_scene() #Reloada nuvarnade scen

func _process(delta):
	if Input.is_action_pressed("Attack_1"): #Om man trycker på attack knappen så anropas attack funktionen 
		attack()
	
	if Input.is_action_just_pressed("Dodge"): #Om man trycker på dodge så anropas dodge funktion
		dodge()
		
	if Input.is_action_just_pressed("Heal"): #Om man trycker på heal knappen så anropas funktionen för heal
		print("healing")
		use_health_potion()
	
	if Input.is_action_just_pressed("Buff"): #Om man trycker på buff knappen så anropas buff funktionen
		print("buff")
		use_damage_potion()
	
func dodge(): 
	if is_dodging or is_attacking: #Om man dodgar eller attackerar så kan man inte anropa funktionen
		return
	
	is_dodging = true #Dodgar är sant
	dodging.play() #Spela dodge ljudet
	speed = 500 #Speed blir 500
	$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1) #Ändra player färg till vit typ
	
	await get_tree().create_timer(DODGE_TIME).timeout #Vänta på att dodge timer är klar
	
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1) #Ändra tillbaka färg på player
	is_dodging = false #Dodgar är falskt
	speed = 170 #Speed är normal
	ATTACK_1_DAMAGE = 18 #Damage blir normal
	ATTACK_2_DAMAGE = 28 #Damage blir normal
	
func player():
	pass

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	pass

func beat_the_games():
	if has_crystal_1:
		if has_crystal_2:
			if has_crystal_3:
				if has_crystal_4:
					global.beat_the_game = true #Om man hittat alla kristaller så blir kraven för att klara ut spelet sant
					if global.take_portal: #Om man tar portalen
						$Fade_transition.show() #Transition animatonen blir synlig
						$Fade_transition/AnimationPlayer.play("fade_in") #Fade in animation spelas
						await $Fade_transition/AnimationPlayer.animation_finished #Vänta på att animation blir klar
						if get_tree():
							get_tree().change_scene_to_file("res://Scenes/credits.tscn") #Byt scen till credits
					
