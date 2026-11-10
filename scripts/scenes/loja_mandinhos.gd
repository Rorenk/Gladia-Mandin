extends Node2D

var card_sorteada: Array[CardResource] = []
var card_rarity_sort = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_cards = _pegar_lista_de_cartas()
	var sorteadas = _sortear_tres(all_cards)

	for card in sorteadas:
		card_sorteada.append(card)
	$Card_1.card_stats = card_sorteada[0]
	$Card_2.card_stats = card_sorteada[1]
	$Card_3.card_stats = card_sorteada[2]
	
	$Card_1._card_init(card_sorteada[0])
	$Card_2._card_init(card_sorteada[1])
	$Card_3._card_init(card_sorteada[2])
	
	$Card_1.create_visuals()
	$Card_2.create_visuals()
	$Card_3.create_visuals()
	
func _pegar_lista_de_cartas() -> Array:
	var arquivos = DirAccess.get_files_at("res://resources/cards/cards_mandinhos/")
	var cards: Array[CardResource] = []

	for arquivo in arquivos:
		if arquivo.ends_with(".tres"):
			var card: CardResource = load("res://resources/cards/cards_mandinhos/" + arquivo)
			if card.card_rarity == card_rarity_sort:
				cards.append(card)
	return cards
	
func _sortear_tres(todas: Array) -> Array:
	if todas.size() < 3:
		push_error("Sprites insuficientes para sortear 3 cards.")
		return []

	var lista = todas.duplicate()
	lista.shuffle()

	return [lista[0], lista[1], lista[2]]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_botao_mandinho_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_mandinhos.tscn")


func _on_botao_itens_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_itens.tscn")


func _on_botao_mobilia_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/loja_scenes/loja_mobilia.tscn")
