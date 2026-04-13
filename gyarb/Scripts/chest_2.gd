extends Area2D

var player_can_open := false #Om player kan öppna kistan
var player_ref = null #Om man håller på att öppna
var opened := false #Om kistan är öppnad

@onready var item_pickup_sound = $item_pickup_sound #Item ljudet

func _ready() -> void:
	$rare_items.visible = false #Göm items
	
func _process(_delta):
	if player_can_open and Input.is_action_just_pressed("Interact") and not opened:
		open_chest()

func open_chest():
	if player_ref and player_ref.use_key():
		opened = true #Om man är i range för att öppna kista och interactar med en nyckel så är opening true och open_chest funktionen anropas
		
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1) #Ändra färg till vit typ
		$AnimatedSprite2D.play("Chest_2") #Spela kist animationen
		
		var loot_animations = ["gold", "health_potion", "damage_potion"] #Lista med items
		var random_loot = loot_animations.pick_random() #Väljer random loot
		
		$rare_items.play(random_loot) #Visar de item som belv valt

		if player_ref.has_method("add_item"): #Om player har metoden för att lägga till item så ska den lägga till de item man fick från kistan
			player_ref.add_item(random_loot)
		
		$AnimationPlayer.play("items") #Spelar animationen för item
		item_pickup_sound.play() #Spelar item ljud
		await $AnimatedSprite2D.animation_finished #Vänta på att animationen är klar
		
		$AnimatedSprite2D.modulate = Color(1,1,1,1) #Ändra tillbaka färgen
		print("Chest opened and key consumed!")
	else:
		$AnimatedSprite2D.modulate = Color(0.66, 0.0, 0.0, 1) #Om man inte har nyckel så blir kistan röd
		
		await get_tree().create_timer(0.3).timeout #Vänta på att timer är klar
		
		$AnimatedSprite2D.modulate = Color(1,1,1,1) #Ändra tillbaka färg

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player i area2d så kan man öppna
		player_can_open = true
		player_ref = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): #Om player lämnar area2d så kan man inte öppna
		player_can_open = false
		player_ref = null
