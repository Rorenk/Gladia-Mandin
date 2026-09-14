extends Node2D


func _ready() -> void:
	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida)
	$CreatureCpuUm._carregar_creature_data(GameState.creature_escolhida)

	$CreaturePlayerUm.alvo = $CreatureCpuUm
	$CreatureCpuUm.alvo = $CreaturePlayerUm

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
