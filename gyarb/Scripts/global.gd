extends Node

#Globala variabler
var player_current_attack = false
var player_position: Vector2
var return_position: Vector2 = Vector2.ZERO
var spawn_position: Vector2 = Vector2(-700, -30)
var just_died := false
var beat_the_game := false
var take_portal := false
var changed_dialogue := false
