extends ProgressBar

@onready var timer = $Timer #Timer för healthbar
@onready var damage_bar = $Damagebar #Damgaebar
var health = 0 : set = _set_health #När health ändras körs funktionen _set_health

func _set_health(new_health):
	var prev_health = health #Sparar tidigare health för att kunna jämföra senare
	health = min(max_value, new_health) #Sätter health:
										#inte över max värdet
										#inte under 0
	value = health #Uppdaterar huvudhealthbaren direkt
	
	if health <= 0: #Om health är 0 healtbar försvinn från skärm
		queue_free()
	
	if health < prev_health: #Om health är mindre än förra health starta healthbar timer
		timer.start() 
	else:
		damage_bar.value = health #Uppdatera damagebar
		

func init_health(_health):
	health = _health #Sätter ett startvärde
	max_value = health #Sätter max health så att man inte kan gå över det
	value = health #uppdatera ui-bar
	#Sätter damagebar max och nuvarande värde
	damage_bar.max_value = health
	damage_bar.value = health
	

func _on_timer_timeout() -> void: #När timer är klar så blir damagebar likadan som healthbar
	damage_bar.value = health
