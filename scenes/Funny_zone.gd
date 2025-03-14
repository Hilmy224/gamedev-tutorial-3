extends Area2D

@onready var purpleman = $AnimatedSprite2D
@onready var fredmusic = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: CharacterBody2D) -> void:
	purpleman.play("default")
	fredmusic.play()


func _on_body_exited(body: Node2D) -> void:
	purpleman.play("Stop")
	fredmusic.stop()
