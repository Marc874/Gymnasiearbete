extends CharacterBody2D

@export var speed: float = 60.0
@export var size_x: float = 300
@export var size_y: float = 64.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var points: Array[Vector2] = []
var current_point: int = 0
var last_direction: Vector2 = Vector2.DOWN

#Talking
var player_in_range = false
var talking = false

func _ready():
	var start_pos = global_position
	
	points = [
		start_pos,
		start_pos + Vector2(size_x, 0),
		start_pos + Vector2(size_x, size_y),
		start_pos + Vector2(0, size_y)
	]

func update_animation(vel: Vector2):

	if abs(vel.x) > abs(vel.y):
		if vel.x > 0:
			sprite.play("walk_right")
		else:
			sprite.play("walk_left")
	else:
		if vel.y > 0:
			sprite.play("walk_down")
		else:
			sprite.play("walk_up")

func _physics_process(delta):
	is_talking()
	
	if talking:
		print("hej")
		sprite.play("talking_down")
		velocity = Vector2.ZERO 
		move_and_slide() 
		return
	
	var target = points[current_point]
	var direction = target - global_position

	if direction.length() > 2:
		velocity = direction.normalized() * speed
		last_direction = velocity.normalized()
		update_animation(velocity)
	else:
		current_point = (current_point + 1) % points.size()
		velocity = Vector2.ZERO

	move_and_slide()

func is_talking():
	if player_in_range and Input.is_action_just_pressed("Interact"):
		talking = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
