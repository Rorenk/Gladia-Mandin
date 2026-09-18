extends AttackBase
class_name MeleeBaseAttack

@export var dano: int
@export var alcance: float
@export var knockback_force: float
@export var knockback_duration: float
@export var attack_particle: PackedScene

func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	alvo.creature_dados.receber_dano(usuario.creature_dados.creature_attack)

	if(has_knockback):
		var direcao := (alvo.global_position - usuario.global_position).normalized()
		alvo.apply_knockback(direcao * knockback_force, knockback_duration)

