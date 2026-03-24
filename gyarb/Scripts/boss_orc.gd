extends CharacterBody2D
class_name Boss_Enemy

var speed = 200
var player_chase = false
var player = null
var current_dir = "down"
@onready var healthbar = $Healthbar

var start_attack := false
var is_attacking := false
var can_attack := true
const ATTACK_DAMAGE := 30
var attack_cooldown_time := 2.5
var attack_cooldown_timer := 0.0
var is_dead := false
var health = 400
var player_inattack_zone = false


func _physics_process(delta):
	if is_dead:
		return
		
	if not can_attack:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0:
			can_attack = true
	
	enemy_attack()

	if is_attacking:
		return
	
	if player_chase:
		var diff = player.position - position
		position += diff / speed

		if abs(diff.x) > abs(diff.y):
			if diff.x < 0:
				$AnimatedSprite2D.play("run_left")
				current_dir = "left"
			else:
				$AnimatedSprite2D.play("run_right")
				current_dir = "right"
		else:
			if diff.y < 0:
				$AnimatedSprite2D.play("run_back")
				current_dir = "up"
			else:
				$AnimatedSprite2D.play("run_front")
				current_dir = "down"
	else:
		if current_dir == "down":
			$AnimatedSprite2D.play("idle_front")
		elif current_dir == "up":
			$AnimatedSprite2D.play("idle_back")
		elif current_dir == "right":
			$AnimatedSprite2D.play("idle_right")
		elif current_dir == "left":
			$AnimatedSprite2D.play("idle_left")
			
func enemy_attack():
	
	if is_attacking:
		return

	if is_dead or not can_attack or not player:
		return

	if player_inattack_zone and player and start_attack:

		is_attacking = true
		print("ATTACKING")
		
		if current_dir == "down":
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_front")
		elif current_dir == "up":
			$AnimatedSprite2D.play("run_attack_back")
		elif current_dir == "right":
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_right")
		elif current_dir == "left":
			$AnimationPlayer.play("Attack")
			$AnimatedSprite2D.play("run_attack_left")
			
		
		
		await get_tree().create_timer(0.5).timeout
		
		if player and player_inattack_zone and player.has_method("take_damage"):
			player.take_damage(ATTACK_DAMAGE)
		await $AnimatedSprite2D.animation_finished
		can_attack = false
		is_attacking = false
		attack_cooldown_timer = attack_cooldown_time
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print("ATTACK")

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func Boss_enemy():
	pass

func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health -= amount
	print("Boss_Enemy HP: ", health)

	if health <= 0:
		is_dead = true
		
		player_chase = false
	
		match current_dir:
			"down":
				$AnimatedSprite2D.play("death_front")
			"up":
				$AnimatedSprite2D.play("death_back")
			"right":
				$AnimatedSprite2D.play("death_right")
			"left":
				$AnimatedSprite2D.play("death_left")
			
		await $AnimatedSprite2D.animation_finished
		
		queue_free()
	
	healthbar.health = health

func _ready():
	$AnimatedSprite2D.play("idle_front")
	healthbar.init_health(health)
	$enemy_hitbox/Sprite2D.visible = false
func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false


func _on_start_attack_body_entered(body: Node2D) -> void:
	start_attack = true


func _on_start_attack_body_exited(body: Node2D) -> void:
	pass 
