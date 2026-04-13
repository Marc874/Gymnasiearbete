extends Area2D

var player_inside = false #Om player är i area2d

func _physics_process(delta):
	open_the_door_please() #Anropar funktionen för att kunna öppna dörren

func open_the_door_please():
	if player_inside == true: #Om player i area2d ändra färg
		$Closed.modulate = Color(2.9, 2.9, 2.9, 1)
		
		if player_inside and Input.is_action_just_pressed("Interact"):
			opening_door() #Om player i area2d och interactar anropa funktionen som öppnar dörren
	else:
		$Closed.modulate = Color(1, 1, 1, 1) #Ändra tillbaka färg

func opening_door():
	#Hämtar sökväg för nuvarande scen
	var scene_path = get_tree().current_scene.scene_file_path
	
	#Kollar om nuvarande scen är node_2d
	if scene_path == "res://Scenes/node_2d.tscn":
		get_tree().change_scene_to_file("res://Scenes/castle.tscn") #Ändra scen
		position = Vector2(0, 0) #Position som man ska börja på
	
	#Kollar om nuvarande scen är castle
	elif scene_path == "res://Scenes/castle.tscn":
		global.return_position = Vector2(-305, 0) #Position som man ska börja på
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn") #Ändra scen
		

func _on_body_entered(body):
	if body.is_in_group("player"): #Om player är i area2d så är varaibel sann
		player_inside = true

func _on_body_exited(body):
	if body.is_in_group("player"): #Om player lämnar area2d så är variabel falsk
		player_inside = false
		
