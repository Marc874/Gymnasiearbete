extends Node2D

var button_type = null #Button har inge värde i början

func _ready() -> void:
	
	$Fade_transition/AnimationPlayer.play("fade_out") #Spela andra halvan av fade animationen
	await $Fade_transition/AnimationPlayer.animation_finished #Vänta tills animation är klar
	$Fade_transition.hide() #Göm animation

func _on_start_pressed() -> void:
	button_type = "start" #Button får värde start
	$Fade_transition.show() #Visa fade animation
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta fade animation

func _on_options_pressed() -> void:
	button_type = "options" #Button får värde start
	$Fade_transition.show() #Visa fade animation
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta animation

func _on_quit_pressed() -> void:
	get_tree().quit() #Stäng av spel om quit knappen trycks

func _on_fade_timer_timeout() -> void:
	if button_type == "start": #Om button har värde start
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn") #Byt scen till node2d
	elif button_type == "options": #Om button har värde options
		get_tree().change_scene_to_file("res://Scenes/options.tscn") #Byt scen till options


func _on_start_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud


func _on_options_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud


func _on_quit_focus_entered() -> void:
	$button_hover_sound.play() #Spela knappljud
