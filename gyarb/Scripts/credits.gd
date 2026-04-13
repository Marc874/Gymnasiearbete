extends Node2D

func _ready() -> void:
	#Spelar andra delen av fade animationen så att det blir en transition
	$Fade_transition/AnimationPlayer.play("fade_out")
	$AnimationPlayer.play("credits")


func _process(delta):
	#Om man trycker ESC så går man till menyn
	if Input.is_action_pressed("Escape"):	#Om escape knappen blir tryckt
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") #Byt scen till main menu
