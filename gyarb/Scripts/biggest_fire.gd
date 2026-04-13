extends CharacterBody2D

func _physics_process(delta: float) -> void:
	fire_play() #Spelar animatoinen konstant

func fire_play():
	$Big_Fire.play("Big_fire_1") #Animationen
