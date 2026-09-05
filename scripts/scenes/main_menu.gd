extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_music()
	



func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/creature_selection.tscn")

func _on_opções_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/opções.tscn")

func _on_sair_pressed() -> void:
	SFXController.trocar("res://assets/audio/sfx/sair.mp3")
	await get_tree().create_timer(1.0).timeout
	get_tree().quit()

func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/creditos.tscn")
