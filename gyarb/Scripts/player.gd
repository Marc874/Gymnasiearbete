extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

const speed = 170
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("Idle_up")
	

func _physics_process(delta):
	
	player_movement(delta)
	enemy_attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	
	if Input.is_action_pressed("Right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("Left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("Down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("Up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movement == 1:
			anim.play("Run_right")
		elif movement == 0:
			anim.play("Idle_right")
	elif dir == "left":
		if movement == 1:
			anim.play("Run_left")
		elif movement == 0:
			anim.play("Idle_left")	
	elif dir == "down":
		if movement == 1:
			anim.play("Run_down")
		elif movement == 0:
			anim.play("Idle_down")	
	elif dir == "up":
		if movement == 1:
			anim.play("Run_up")
		elif movement == 0:
			anim.play("Idle_up")		
			
func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health -10
		enemy_attack_cooldown = false
		$Attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true
