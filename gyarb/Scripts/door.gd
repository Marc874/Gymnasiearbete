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
	var scene_path = get_tree().current_scene.scene_file_path
	
	if scene_path == "res://Scenes/node_2d.tscn":
		global.return_position = Vector2(160, 100)
		get_tree().change_scene_to_file("res://Scenes/castle.tscn")
		
	elif scene_path == "res://Scenes/castle.tscn":
		global.return_position = Vector2(384, -50)
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn")

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		
