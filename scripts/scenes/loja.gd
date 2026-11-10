extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var card: Card = Card.new(load("uid://l56l266p286y"))
	#add_child(card)
	#card.position = Vector2(40, 57)
	#card.size = Vector2(32, 32)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_mandinho_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_mandinhos.tscn")


func _on_botao_itens_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_itens.tscn")


func _on_botao_mobilia_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_mobilia.tscn")
