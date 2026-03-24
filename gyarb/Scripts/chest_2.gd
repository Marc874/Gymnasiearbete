extends Area2D

var player_can_open := false
var player_ref = null
var opened := false

func _ready() -> void:
	$rare_items.visible = false

func _process(_delta):
	if player_can_open and Input.is_action_just_pressed("Interact") and not opened:
		open_chest()

func open_chest():
	if player_ref and player_ref.use_key():
		opened = true
		
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1)
		$AnimatedSprite2D.play("Chest_2")
		
		var loot_animations = ["gold", "health_potion", "damage_potion"]
		var random_anim = loot_animations.pick_random()
		$rare_items.play(random_anim)
		
		$AnimationPlayer.play("items")
		
		await $AnimatedSprite2D.animation_finished
		
		$AnimatedSprite2D.modulate = Color(1,1,1,1)
		print("Chest opened and key consumed!")
	else:
		$AnimatedSprite2D.modulate = Color(0.66, 0.0, 0.0, 1)
		
		await get_tree().create_timer(0.3).timeout
		
		$AnimatedSprite2D.modulate = Color(1,1,1,1)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_can_open = true
		player_ref = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_can_open = false
		player_ref = null
