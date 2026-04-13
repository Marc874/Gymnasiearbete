extends Area2D

var player_can_pickup := false #Om player kan plocka upp nyckel (Är inuti area2d)
var player_ref = null #Player referens är ingeting(null)

func _process(_delta):
	if player_can_pickup and Input.is_action_just_pressed("Interact"): #Om kan plocka upp nyckel och interactar
		pickup() #Anropa pickup funktion

func pickup():
	if player_ref: #Om player referens player anropa pickup key funktion och nyckel ska försvinna
		player_ref.pickup_key()
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player i area2d variabel blir sann, player ref får en kropp och nyckel ändrar färg
		$Key.modulate = Color(2.9, 2.9, 2.9, 1)
		player_can_pickup = true
		player_ref = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player lämnar area 2d variabel blir falsk, player ref blir null och nyckel återvänder till orginal färg
		$Key.modulate = Color(1, 1, 1, 1)
		player_can_pickup = false
		player_ref = null
