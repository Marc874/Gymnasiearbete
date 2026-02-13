extends Area2D

var player_inside = false

func _physics_process(delta):
	open_the_door_please()

func open_the_door_please():
	if player_inside == true:
		$Closed.modulate = Color(2.9, 2.9, 2.9, 1)
		
		if player_inside and Input.is_action_just_pressed("Interact"):
			opening_door()
	else:
		$Closed.modulate = Color(1, 1, 1, 1)

func opening_door():
	get_tree().change_scene_to_file("res://Scenes/castle.tscn")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		
