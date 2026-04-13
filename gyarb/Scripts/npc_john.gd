extends CharacterBody2D

#Kordinater för hans walking path
@export var speed: float = 60.0
@export var size_x: float = 300
@export var size_y: float = 64.0

#Animations variablen
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var points: Array[Vector2] = [] #Kollar punkterna
var current_point: int = 0 #Aktuell punkt
var last_direction: Vector2 = Vector2.DOWN #Senaste riktningen

#Talking
var player_in_range = false #Om spelaren är i range för att aktiveras
var talking = false #Pratar status

func _ready():
	var start_pos = global_position #Start position
	
	#Punkter
	points = [ 
		start_pos,
		start_pos + Vector2(size_x, 0),
		start_pos + Vector2(size_x, size_y),
		start_pos + Vector2(0, size_y)
	]

func update_animation(vel: Vector2):

	if abs(vel.x) > abs(vel.y):
		if vel.x > 0: #Gå höger
			sprite.play("walk_right")
		else: #Gå vänster
			sprite.play("walk_left")
	else:
		if vel.y > 0: #Gå ner
			sprite.play("walk_down")
		else: #Gå upp
			sprite.play("walk_up")

func _physics_process(delta):
	is_talking() #Anropar prat funktionen konstant
	
	if talking: #Om man pratar så kollar gubben ner och dilaogue anmimationen börjar
		sprite.play("talking_down") 
		$Dialogue.show()
		if global.changed_dialogue: #Om man dör så ändras dialogue
			$Dialogue/AnimationPlayer.play("dialogue_2")
		else: #Om man inte dör så är det dialogue 1
			$Dialogue/AnimationPlayer.play("dialogue_1")
		velocity = Vector2.ZERO #Velocity blir 0 = står stilla
		move_and_slide() #När man pratar ska npc stå still
		return
	
	var target = points[current_point] #Riktning som man ska sikta på är den nuvarande punkten
	var direction = target - global_position 

	#Kolla om vi fortfarande är en bit ifrån målpunkten
	if direction.length() > 2:
		velocity = direction.normalized() * speed #Sätt hastigheten i riktning mot målet
		last_direction = velocity.normalized() #Spara senaste riktningen
		update_animation(velocity) #Uppdatera animation baserat på rörelse
	else:
		current_point = (current_point + 1) % points.size() #Om framme gå till nästa punkt i listan
		
		velocity = Vector2.ZERO #Stanna
	
	move_and_slide()# Flytta karaktären baserat på velocity

func is_talking():
	if player_in_range and Input.is_action_just_pressed("Interact"): #Om man är i npc area2d och trycker intereact börjar man prata
		talking = true #Prat status blir uppfylld

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): #Om grupp är player
		player_in_range = true #Player är i area2d
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): #Om grupp är player
		player_in_range = false #Player är inte i area2d
