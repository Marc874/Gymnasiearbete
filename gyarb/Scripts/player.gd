
extends CharacterBody2D

var has_key := false
var health = 100
var player_alive = true
var inventory = []

var is_dodging := false
const DODGE_TIME := 0.2
var current_attack_damage := 0
const ATTACK_1_DAMAGE := 18
const ATTACK_2_DAMAGE := 50
var is_attacking := false
var is_moving := false
var attack_cooldown := 0.3
var can_attack := true

var speed = 170
var current_dir = "none"

func _ready():
	add_to_group("player")
	$AnimatedSprite2D.play("Idle_up")

func pickup_key():
	has_key = true
	print("Player now has key:", has_key)

func use_key() -> bool:
	if has_key:
		has_key = false
		return true
	return false

func _physics_process(delta):
	if is_attacking:
		move_and_slide()
		return
		
	if not can_attack:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			can_attack = true
	player_movement(delta)

func player_movement(delta):
	is_moving = false
	
	if Input.is_action_pressed("Right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
		is_moving = true
	elif Input.is_action_pressed("Left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
		is_moving = true
	elif Input.is_action_pressed("Down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
		is_moving = true
	elif Input.is_action_pressed("Up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
		is_moving = true
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		is_moving = false
	
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

func attack():
	if is_attacking:
		return

	is_attacking = true
		
	var attack_name := ""
	var bodies = $Player_hitbox.get_overlapping_bodies()
	
	if is_moving:
		attack_name = "Attack_2"
		current_attack_damage = ATTACK_2_DAMAGE
	else:
		attack_name = "Attack_1"
		current_attack_damage = ATTACK_1_DAMAGE
	
	for body in bodies:
		if body is Enemy:
			body.take_damage(current_attack_damage)
			
	match current_dir:
		"right":
			$AnimatedSprite2D.play(attack_name + "_right")
		"left":
			$AnimatedSprite2D.play(attack_name + "_left")
		"up":
			$AnimatedSprite2D.play(attack_name + "_up")
		"down":
			$AnimatedSprite2D.play(attack_name + "_down")
		
	await $AnimatedSprite2D.animation_finished

	is_attacking = false
	play_anim(0)

func take_damage(amount: int) -> void:
	if is_dodging:
		return

	health -= amount
	print("Player HP:", health)
	if health <= 0:
		$AnimatedSprite2D.modulate = Color(0.66, 0.0, 0.0, 1)
		
		die()

func die():
	player_alive = false
	print("player has been killed")
	
	queue_free()
		
func _process(delta):
	if Input.is_action_pressed("Attack_1"):	
		attack()
	
	if Input.is_action_just_pressed("Dodge"):
		dodge()
		
	if Input.is_action_pressed("Escape"):	
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func dodge():
	if is_dodging or is_attacking:
		return
	
	is_dodging = true
	speed = 400
	$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1)
	
	await get_tree().create_timer(DODGE_TIME).timeout
	
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	is_dodging = false
	speed = 170
	
func player():
	pass

"""
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and is_attacking:
		body.take_damage(current_attack_damage)
"""

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	pass
