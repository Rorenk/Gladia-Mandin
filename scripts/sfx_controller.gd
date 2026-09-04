extends Node2D


# Called when the node enters the scene tree for the first time.
func trocar(caminho: String) -> void:
	$SFX.stream = load(caminho)
	$SFX.play()
