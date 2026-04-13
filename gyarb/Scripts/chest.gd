extends Area2D

var player_can_open = false #Om player kan öppna kistan
var opening = false #Om man håller på att öppna
var opened = false #Om kistan är öppnad

@onready var coin_sound = $coin_sound #Coin ljudet

func _ready() -> void:
	$coin.visible = false #Göm coin

func _physics_process(delta):
	opening_chest() #Anropar chest funktionen

func opening_chest():
	if player_can_open == true:
		if player_can_open and Input.is_action_just_pressed("Interact"):
			opening = true #Om man är i range för att öppna kista och interactar så är opening true och open_chest funktionen anropas
			open_chest()
			
func open_chest():
	if opening == true and not opened: #Om man öppnar och kistan inte är öppnad
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1) #Ändra färg
		$AnimatedSprite2D.play("Chest_1") #Spela kist animationen
		$coin.visible = true #Coin blir visible
		$AnimationPlayer.play("coin_equip") #Spela coin upplocknings animation
		$coin.play("coin")	 #Spelar coin passive animation
		coin_sound.play() #Spela coin ljudet
		await $coin.animation_finished #Vänta på att coin animation är klar
		$coin.visible = false #Göm coin

		await $AnimatedSprite2D.animation_finished #Vänta på att kist animation är klar

		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1) #Ändra tillbaka färg
		opening = false #Öppnar = false
		opened = true #Öppnad = true
			
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player i area2d så kan man öppna
		player_can_open = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player lämnar area2d så kan man inte öppna
		player_can_open = false 
