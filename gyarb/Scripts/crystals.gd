extends Area2D

var player_can_pickup := false
var player_ref = null

func _process(_delta):
	if player_can_pickup and Input.is_action_just_pressed("Interact"):
		pickup()
	$AnimationPlayer.play("passive")
	
func pickup():
	if player_ref:
		player_ref.pickup_crystal()
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1)
		player_can_pickup = true
		player_ref = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
		player_can_pickup = false
		player_ref = null
