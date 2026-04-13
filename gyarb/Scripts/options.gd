extends Node2D

var button_type = null #Button har inget värde i början

func _ready() -> void:
		$Fade_transition/AnimationPlayer.play("fade_out") #Spela andra halvan av fade animation
		await $Fade_transition/AnimationPlayer.animation_finished #Vänta tills fade animation är klar
		$Fade_transition.hide() #Göm fade animation
		
func _on_settings_pressed() -> void:
	button_type = "settings" #Button får värde settings
	$Fade_transition.show() #Visa fade animation
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta fade animation

func _on_instructions_pressed() -> void:
	button_type = "instructions" #Button får värde instructions
	$Fade_transition.show() #Visa fade animation
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta fade animation

func _on_main_menu_pressed() -> void:
	button_type = "main_menu" #Button får värde main menu
	$Fade_transition.show() #Visa fade animation
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta fade animation

func _on_fade_timer_timeout() -> void:
	if button_type == "settings": #Om button har värde settings
		get_tree().change_scene_to_file("res://Scenes/settings.tscn") #Byt scen till settings
	elif button_type == "instructions": #Om button har värde instructions 
		get_tree().change_scene_to_file("res://Scenes/instructions.tscn") #Byt scen till instructions
	elif button_type == "main_menu": #Om button har värde main menu
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") #Byt scen till main menu


func _on_settings_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud


func _on_instructions_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud


func _on_main_menu_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud
