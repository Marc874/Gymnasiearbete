extends Node2D

var button_type = null #Button har inge värde i början

func _ready() -> void:
		$Fade_transition/AnimationPlayer.play("fade_out") #Spela andra delen av fade animationen
		await $Fade_transition/AnimationPlayer.animation_finished #Vänta tills animation är klar
		$Fade_transition.hide() #Göm animationen
		
func _on_exit_pressed() -> void:
	button_type = "options" #Button får värde options
	$Fade_transition.show() #Visa fade animationen
	$Fade_transition/Fade_timer.start() #Starta timer
	$Fade_transition/AnimationPlayer.play("fade_in") #Starta animation

func _on_fade_timer_timeout() -> void:
	if button_type == "options": #Om button är opotions
		get_tree().change_scene_to_file("res://Scenes/options.tscn") #Ändra scen till options


func _on_exit_focus_entered() -> void:
	$button_hover_sound.play() #Spela klickljud för knappen
