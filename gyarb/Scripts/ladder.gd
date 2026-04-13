extends Area2D

var player_inside = false #Om player är i area2d

func _physics_process(delta):
	climb_the_ladder_please() #Anropar funktionen för att klättra stegen

func climb_the_ladder_please():
		if player_inside and Input.is_action_just_pressed("Interact"): #Om player är i area2d och man trycker interact
			climbing_ladder() #Klättrar stegen anropas

func climbing_ladder():
	get_tree().change_scene_to_file("res://Scenes/castle_second_floor.tscn") #Ändrar scen

func _on_body_entered(body):
	if body.is_in_group("player"): #Om player i area2d så är variabeln sant
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"): #Om player lämnar area2d så är variablen falsk
		player_inside = false
