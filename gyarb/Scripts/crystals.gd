extends Area2D

#Variabler
var player_can_pickup := false
var player_ref = null

func _process(_delta):
	#Anropar pickup funktionen om player är i kristallens area2d och om, man trycker på interact knappen
	if player_can_pickup and Input.is_action_just_pressed("Interact"):
		pickup()
	#Gör så kristallen har sin idle animation
	$AnimationPlayer.play("passive")
	
func pickup(): #Om player plockar upp kristall försvinn från skärmen
	if player_ref:
		player_ref.pickup_crystal_1() 
		queue_free() 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player ändra färg och player kan plocka upp kristall
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1)
		player_can_pickup = true
		player_ref = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player ändra tillbaka färg och player kan inte plocka upp kristall
		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
		player_can_pickup = false
		player_ref = null
