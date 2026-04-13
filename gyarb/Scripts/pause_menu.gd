extends Control

func _ready():
	$AnimationPlayer.play("RESET") #Resettar pausmenyn i början 

func resume():
	get_tree().paused = false #Paus är falskt
	$AnimationPlayer.play("resume") #Spela animation resume

func pause():
	get_tree().paused = true #Pausa spelet
	$AnimationPlayer.play("pause") #Spela paus animation

func testESC():
	if Input.is_action_just_pressed("Escape") and !get_tree().paused: #Om ESC blir tryckt och spelet inte är pausat
		pause() #Pausa
	elif Input.is_action_just_pressed("Escape") and get_tree().paused: #Om ESC blur tryckt och spelet är pausat
		resume() #Avsluta pausen
		

func _on_resume_pressed() -> void:
	resume() #Avsluta pausläge
	$AudioStreamPlayer2D.play() #Klickljud

func _on_exit_pressed() -> void:
	resume() #Avsluta pausläge
	$AudioStreamPlayer2D.play() #Klickljud
	await $AudioStreamPlayer2D.finished #Vänta tills ljud är klar
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn") #Byt scen till main menu
	
func _on_restart_pressed() -> void:
	resume() #Avsluta pausläge
	var scene_path = get_tree().current_scene.scene_file_path
	$AudioStreamPlayer2D.play() #Klickljud
	await $AudioStreamPlayer2D.finished #Vänta tills ljudet är klar
	if scene_path == "res://Scenes/node_2d.tscn": #Om nuvarande scen är node2d reloada scen
		get_tree().reload_current_scene() #Restarta spelet
	elif scene_path == "res://Scenes/castle.tscn": #Om nuvarande scen är castle
		get_tree().change_scene_to_file("res://Scenes/node_2d.tscn") #Byt scen till node2d
	
func _process(delta):
	testESC() #Anropa funktionen så att ESC-knappen funkar
