extends CharacterBody2D

var speed = 25
var player_chase = false
var player = null
var current_dir = "none"

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed

		$AnimatedSprite2D.play("Orc_1_walk_left")
	else:
		$AnimatedSprite2D.play("Orc_1_idle_front")


func _on_detection_area_body_entered(body):
	player = body
	print("hej")
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
