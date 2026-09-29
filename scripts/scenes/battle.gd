extends Node2D

const time_player : int = 2
const time_cpu : int = 3

func _ready() -> void:
	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))
	$CreatureCpuUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))
	
	$CreaturePlayerUm.alvo = $CreatureCpuUm
	$CreatureCpuUm.alvo = $CreaturePlayerUm
	
	$CreaturePlayerUm.definir_time(time_player, [time_cpu])
	$CreatureCpuUm.definir_time(time_cpu, [time_player])
	
