extends CharacterBody2D
class_name Enemy #Klass namnet defineras

var speed = 100 #Speed variabel
var player_chase = false #Fienden jagar inte player från början
var player = null #Player är ingeting
var current_dir = "down" #Start riktning är nedåt
@onready var healthbar = $Healthbar #Kopplar healtbar till koden

var is_attacking := false #Variablen fär om enemy attackerar 
var can_attack := true #Variabeln för om enemy kan attackera
const ATTACK_DAMAGE := 10 #Enemy attack damage
var attack_cooldown_time := 0.8 #Längd på attack cooldown
var attack_cooldown_timer := 0.0 #Tiden som timer ska nå
var is_dead := false #Variabel för om enemy lever
var health = 60 #Enemy health
var player_inattack_zone = false #Om player är inom attackarea

func _physics_process(delta):
	if is_dead: #Om död så kan inte funktionen anropas
		return
		
	if not can_attack: #Hantera attack cooldown
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0:
			can_attack = true
			
	enemy_attack() #Anropa attack funktion
	
	if player_chase: #Om spelaren upptäcks så ska enemy jaga den
		var diff = player.position - position #Räkna ut riktning mot spelaren
		position += diff / speed #Flytta mot spelaren

		if abs(diff.x) > abs(diff.y): #Bestämmer om vi ska använda x eller y riktning för animationen genom att kolla vilken som är störst
			if diff.x < 0: #Rörelse vänster
					if is_attacking:
						$AnimatedSprite2D.play("Orc_1_attack_1_left")
						current_dir = "left"
					else:
						$AnimatedSprite2D.play("Orc_1_walk_left")
						current_dir = "left"
			else: #Höger
				if is_attacking:
					$AnimatedSprite2D.play("Orc_1_attack_1_right")
					current_dir = "right"
				else:
					$AnimatedSprite2D.play("Orc_1_walk_right")
					current_dir = "right"
		else: #Om y riktning är större
			if diff.y < 0: #Up
				if is_attacking:
					$AnimatedSprite2D.play("Orc_1_attack_1_back")
					current_dir = "up"
				else:
					$AnimatedSprite2D.play("Orc_1_walk_back")
					current_dir = "up"
			else: #Ner
				if is_attacking:
					$AnimatedSprite2D.play("Orc_1_attack_1_front")
					current_dir = "down"
				else:
					$AnimatedSprite2D.play("Orc_1_walk_front")
					current_dir = "down"
	else: #Om enemy inte jagar
		if current_dir == "down": #Ner idle
			$AnimatedSprite2D.play("Orc_1_idle_front")
		elif current_dir == "up": #Up idle
			$AnimatedSprite2D.play("Orc_1_idle_back")
		elif current_dir == "right": #Höger idle
			$AnimatedSprite2D.play("Orc_1_idle_right")
		elif current_dir == "left": #Vänster idle
			$AnimatedSprite2D.play("Orc_1_idle_left")
			
func enemy_attack():
	if is_attacking: #Om redan attackerar avbryt
		return
		
	if is_dead or not can_attack: #Om död eller inte kan attackera avbryt
		return

	if player_inattack_zone and player: #Om spelare i attackzon
		
		is_attacking = true #Attackerar är sant
		
		#Spela attack animation beroende på riktning
		if current_dir == "down": #Ner
			$AnimatedSprite2D.play("Orc_1_attack_1_front")
		elif current_dir == "up": #Up
			$AnimatedSprite2D.play("Orc_1_attack_1_back")
		elif current_dir == "right": #Höger
			$AnimatedSprite2D.play("Orc_1_attack_1_right")
		elif current_dir == "left": #Vänster
			$AnimatedSprite2D.play("Orc_1_attack_1_left")
			
		$sound/attack.play() #Spela attackljud
		await get_tree().create_timer(0.4).timeout #Skapa timer
		
		if player and player_inattack_zone and player.has_method("take_damage"): #Om player i attackzon så ska den ta damage
			player.take_damage(ATTACK_DAMAGE)
		can_attack = false 
		is_attacking = false #Attackerar är falskt
		attack_cooldown_timer = attack_cooldown_time #Timer reset
		
		
func _on_detection_area_body_entered(body):
	player = body #Spelaren har kropp
	player_chase = true #Jagar spelaren är sant
	print("ATTACK")

func _on_detection_area_body_exited(body):
	player = null #Player är ingeting
	player_chase = false #Jag inte spelaren
	
func enemy():
	pass

func take_damage(amount: int) -> void:
	if is_dead: #Om död avbryt
		return
	
	health -= amount #Health är de health man hade innan minus player attack
	print("Enemy HP: ", health)

	if health <= 0: #Om health är noll så är enemy död
		is_dead = true
		
		player_chase = false #Jag inte spelaren
	
		match current_dir: #Matchar death animation med den riktning enemy dog i.
			"down":
				$AnimatedSprite2D.play("Orc_1_death_front")
			"up":
				$AnimatedSprite2D.play("Orc_1_death_back")
			"right":
				$AnimatedSprite2D.play("Orc_1_death_right")
			"left":
				$AnimatedSprite2D.play("Orc_1_death_left")
			
		await $AnimatedSprite2D.animation_finished #Vänta tills animation är klar
		
		queue_free() #Enemy kropp försvinner
	
	healthbar.health = health #Healthbar visar de health enemy har

func _ready():
	$AnimatedSprite2D.play("Orc_1_idle_front") #Spela start animatoin
	healthbar.init_health(health) #Healthbar visar health

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player")and not body.is_dodging: #Om player gick in i area2d och inte dodgar så är player i detected och ska jagas
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"): #Om player lämnar area2d så jagar enemy inte längre.
		player_inattack_zone = false
