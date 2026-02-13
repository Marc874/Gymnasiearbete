extends CharacterBody2D
class_name Enemy

var speed = 100
var player_chase = false
var player = null
var current_dir = "down"

var can_attack := true
const ATTACK_DAMAGE := 10
var attack_cooldown_time := 0.8
var attack_cooldown_timer := 0.0
var is_dead := false
var health = 60
var player_inattack_zone = false

func _physics_process(delta):
	if is_dead:
		return
		
	if not can_attack:
		attack_cooldown_timer -= delta
		if attack_cooldown_timer <= 0:
			can_attack = true
			
	enemy_attack()
	
	if player_chase:
		var diff = player.position - position
		position += diff / speed

		if abs(diff.x) > abs(diff.y):
			if diff.x < 0:
				$AnimatedSprite2D.play("Orc_1_walk_left")
				current_dir = "left"
			else:
				$AnimatedSprite2D.play("Orc_1_walk_right")
				current_dir = "right"
		else:
			if diff.y < 0:
				$AnimatedSprite2D.play("Orc_1_walk_back")
				current_dir = "up"
			else:
				$AnimatedSprite2D.play("Orc_1_walk_front")
				current_dir = "down"
	else:
		if current_dir == "down":
			$AnimatedSprite2D.play("Orc_1_idle_front")
		elif current_dir == "up":
			$AnimatedSprite2D.play("Orc_1_idle_back")
		elif current_dir == "right":
			$AnimatedSprite2D.play("Orc_1_idle_right")
		elif current_dir == "left":
			$AnimatedSprite2D.play("Orc_1_idle_left")
			
func enemy_attack():
	if is_dead or not can_attack:
		return

	if player_inattack_zone and player:
		player.take_damage(ATTACK_DAMAGE)
		can_attack = false
		attack_cooldown_timer = attack_cooldown_time
		
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print("ATTACK")

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass

func take_damage(amount: int) -> void:
	if is_dead:
		return
	
	health -= amount
	print("Enemy HP: ", health)

	if health <= 0:
		is_dead = true
		
		player_chase = false
		
		match current_dir:
			"down":
				$AnimatedSprite2D.play("Orc_1_death_front")
			"up":
				$AnimatedSprite2D.play("Orc_1_death_back")
			"right":
				$AnimatedSprite2D.play("Orc_1_death_right")
			"left":
				$AnimatedSprite2D.play("Orc_1_death_left")
			
		await $AnimatedSprite2D.animation_finished
		
		queue_free()

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player")and not body.is_dodging:
		player_inattack_zone = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false
