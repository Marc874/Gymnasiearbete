extends Area2D

var player_inside = false

func _physics_process(delta):
	climb_the_ladder_please()

func climb_the_ladder_please():
		if player_inside and Input.is_action_just_pressed("Interact"):
			climbing_ladder()

func climbing_ladder():
	get_tree().change_scene_to_file("res://Scenes/castle_second_floor.tscn")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
