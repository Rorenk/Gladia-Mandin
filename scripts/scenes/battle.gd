extends Node2D


func _ready() -> void:
	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))
	$CreatureCpuUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))

	$CreaturePlayerUm.alvo = $CreatureCpuUm
	$CreatureCpuUm.alvo = $CreaturePlayerUm

