extends Area2D

var player_inside = false #Om player är i area2d


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if global.beat_the_game: #Om player klarat ut spelet
		$".".show() #Portal visas
	$AnimatedSprite2D.play("portal") #Spela portal animation
	taking_portal() #Anropa funktionen för att använda portalen

func take_portal():
	global.take_portal = true #Variabeln för att man tagit portalen blir sann

func taking_portal():
	if player_inside and Input.is_action_just_pressed("Interact"): #Om player i area2d och interactar
			take_portal() #Anropa ta portal funktionen

func _on_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"): #Om player i area2d variabel är sann
			player_inside = true


func _on_body_exited(body: Node2D) -> void:
		if body.is_in_group("player"): #Om player lämnar area2d är variabel falsk
			player_inside = false
