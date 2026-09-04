extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func play_music():
	if not $bgmusic.playing:
		$bgmusic.play()

