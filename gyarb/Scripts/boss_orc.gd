extends CharacterBody2D
class_name Boss_Enemy #Definerar klass

var speed = 200 #Boss speed
var player_chase = false #Boss jagar inte spelaren
var player = null #Spelaren har inge värde
var current_dir = "down" #Start riktning är ner
@onready var healthbar = $Healthbar #Kopplar healthbar till koden

var start_attack := false #Starta attack är falsk i början
var is_attacking := false #Attackerar är falskt i början
var can_attack := true #Kan attackera
const ATTACK_DAMAGE := 30 #Boss damage
var attack_cooldown_time := 2.5 #Timer tid för attack cooldown
var attack_cooldown_timer := 0.0 #Den tid timer ska ta slut
var is_dead := false #Boss är vid liv
var health = 400 #Boss health
var player_inattack_zone = false #Player är inte i attackzon


func _physics_process(delta):
	if is_dead: #Om död avbryt
		return
		
	if not can_attack: #Hanterar timer
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0:
			can_attack = true
	
	enemy_attack() #Anropar attack funktion

	if is_attacking: #Om attackerar avbryt
		return
	
	if player_chase: #OM jagar spelaren
		var diff = player.position - position #Räkna ut riktning mot spelaren
		position += diff / speed #Rör sig mot spelaren

		if abs(diff.x) > abs(diff.y): #Bestämmer om vi ska använda x eller y riktning för animationen genom att kolla vilken som är störst
			if diff.x < 0: #Vänster
				$AnimatedSprite2D.play("run_left")
				current_dir = "left"
			else: #Vänster
				$AnimatedSprite2D.play("run_right")
				current_dir = "right"
		else:  #Y riktning är större 
			if diff.y < 0: #Up
				$AnimatedSprite2D.play("run_back")
				current_dir = "up"
			else: #Ner
				$AnimatedSprite2D.play("run_front")
				current_dir = "down"
	else: #Om man inte rör sig
		if current_dir == "down": #Idle ner
			$AnimatedSprite2D.play("idle_front")
		elif current_dir == "up": #Idle upp
			$AnimatedSprite2D.play("idle_back")
		elif current_dir == "right": #Idle höger
			$AnimatedSprite2D.play("idle_right")
		elif current_dir == "left": #Idle vänster
			$AnimatedSprite2D.play("idle_left")
			
func enemy_attack():
	
	if is_attacking: #Om attackerar avbryt
		return

	if is_dead or not can_attack or not player: #Om död eller inte player eller inte kan attackera avbryt
		return

	if player_inattack_zone and player and start_attack: #Om spelare i attackzon och player och startar attack

		is_attacking = true #Attackerar
		print("ATTACKING")
		
		if current_dir == "down": #Attack ner
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_front")
		elif current_dir == "up": #Attack up
			$AnimatedSprite2D.play("run_attack_back")
		elif current_dir == "right": #Attack höger
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_right")
		elif current_dir == "left": #Attack vänster
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_left")
			
		$sound/attack.play() #Spelaren boss attack ljud
		await get_tree().create_timer(0.5).timeout #Skapar timer för attack cooldown
		
		if player and player_inattack_zone and player.has_method("take_damage"): #Om player i attackzon och har metod som tillåter player att ta damage så ska player ta damage
			player.take_damage(ATTACK_DAMAGE)
		await $AnimatedSprite2D.animation_finished #Vänta på animationen
		can_attack = false #Kan inte attackera
		is_attacking = false #Attackerar
		attack_cooldown_timer = attack_cooldown_time #Timer reset
		
		
func _on_detection_area_body_entered(body):
	player = body #Player får kropp
	player_chase = true #Enemy jagar player
	print("ATTACK")
	$sound/boss_music.play() #Starta boss musik
	
func _on_detection_area_body_exited(body):
	player = null #Player får inget värde
	player_chase = false #Enemy jagar inte player
	
func Boss_enemy():
	pass

func take_damage(amount: int) -> void:
	if is_dead: #Om död avbryt
		return
	
	health -= amount #Health är senaste health minus player attack
	print("Boss_Enemy HP: ", health)

	if health <= 0: #Om player health är 0 så är enemy död
		is_dead = true
		
		player_chase = false #Enemy jagar inte spelaren
	
		match current_dir: #Matchar riktningen med animationen
			"down": #Ner
				$AnimatedSprite2D.play("death_front")
			"up": #Upp
				$AnimatedSprite2D.play("death_back")
			"right": #Höger
				$AnimatedSprite2D.play("death_right")
			"left": #Vänster
				$AnimatedSprite2D.play("death_left")
			
		await $AnimatedSprite2D.animation_finished #Vänta tills animation är klar
		
		queue_free() #Boss kropp försvinner
	
	healthbar.health = health #Healthbar visar health

func _ready():
	$AnimatedSprite2D.play("idle_front") #Start animation
	healthbar.init_health(health) #Kopplar healtbar till scen
	
	$enemy_hitbox/Sprite2D.visible = false #Gömmer attackzonen
	
func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"): #Om player är i area2d så kan bossen attackera
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"): #Om player lämnar area2d så kan den inte attackera player
		player_inattack_zone = false


func _on_start_attack_body_entered(body: Node2D) -> void:
	start_attack = true #Starta första attacken när den nått aktivations area2d


func _on_start_attack_body_exited(body: Node2D) -> void:
	pass 
