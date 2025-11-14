extends CharacterBody2D

const speed = 150
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("Idle_up")
	

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
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
			

	
	
	


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
