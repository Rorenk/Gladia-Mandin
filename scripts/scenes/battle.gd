extends Node2D


func _ready() -> void:
	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida)
	$CreaturePlayerUm.scale = Vector2(1.0, 1.0)
	$CreatureCpuUm._carregar_creature_data(GameState.creature_escolhida)
	$CreatureCpuUm.scale = Vector2(1.0, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
