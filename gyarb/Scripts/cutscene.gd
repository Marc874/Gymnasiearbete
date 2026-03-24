extends Area2D

var cutscene_start := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	cutscene_start = true


func _on_body_exited(body: Node2D) -> void:
	cutscene_start = false
