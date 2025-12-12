extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null
var current_dir = "down"

var health = 60
var player_inattack_zone = false

func _physics_process(delta):
	deal_with_damage()
	
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
			


func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	print("ATTACK")
	
"""
	if current_dir == "left":
		$AnimatedSprite2D.play("Orc_1_idle_left")
	elif current_dir == "right":
		$AnimatedSprite2D.play("Orc_1_idle_right")
	elif current_dir == "up":
		$AnimatedSprite2D.play("Orc_1_idle_up")
	elif current_dir == "down":
		$AnimatedSprite2D.play("Orc_1_idle_down")
"""
	

func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	
func enemy():
	pass

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		health = health -20
		print("slime health = ", health)
		if health <= 0:
			self.queue_free()
