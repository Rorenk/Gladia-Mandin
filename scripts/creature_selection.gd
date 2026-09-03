extends Node2D

var creature_sorteada: Array[CreatureResource] = []
var creature_form_sort = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var all_creatures = _pegar_lista_de_creatures()
	var sorteadas = _sortear_tres(all_creatures)

	for creature in sorteadas:
		creature_sorteada.append(creature)

	$CreatureUm.sprite_frames = creature_sorteada[0].creature_sprite_sheet
	$CreatureDois.sprite_frames = creature_sorteada[1].creature_sprite_sheet
	$CreatureTres.sprite_frames = creature_sorteada[2].creature_sprite_sheet	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _pegar_lista_de_creatures() -> Array:
	var arquivos = DirAccess.get_files_at("res://resources/creatures/")
	var creatures: Array[CreatureResource] = []

	for arquivo in arquivos:
		if arquivo.ends_with(".tres"):
			var creature: CreatureResource = load("res://resources/creatures/" + arquivo)
			if creature.creature_form == creature_form_sort:
				creatures.append(creature)
	return creatures

func _sortear_tres(todas: Array) -> Array:
	if todas.size() < 3:
		push_error("Sprites insuficientes para sortear 3 creatures.")
		return []


	var lista = todas.duplicate()
	lista.shuffle()

	return [lista[0], lista[1], lista[2]]
