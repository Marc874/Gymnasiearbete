extends Node2D

func _ready() -> void:
		$Fade_transition/AnimationPlayer.play("fade_out") #Gör så att skärmen går från svart till synlig
		await $Fade_transition/AnimationPlayer.animation_finished #Vänta på att animationen är klar
		$Fade_transition.hide() #Göm själva animationen
