extends Area2D

var player_can_open = false
var opening = false
var opened = false

func _ready() -> void:
	$coin.visible = false

func _physics_process(delta):
	opening_chest()

func opening_chest():
	if player_can_open == true:
		if player_can_open and Input.is_action_just_pressed("Interact"):
			opening = true
			open_chest()
			
func open_chest():
	if opening == true and not opened:
		$AnimatedSprite2D.modulate = Color(2.9, 2.9, 2.9, 1)
		$AnimatedSprite2D.play("Chest_1")
		$coin.visible = true
		$AnimationPlayer.play("coin_equip")
		$coin.play("coin")	
		await $coin.animation_finished
		$coin.visible = false
		
		await $AnimatedSprite2D.animation_finished

		$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
		opening = false
		opened = true
			
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_can_open = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_can_open = false
