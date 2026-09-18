extends AttackBase
class_name MeleeBaseAttack

@export var dano: int
@export var alcance: float
@export var knockback_force: float
@export var knockback_duration: float

func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	print("Ataque usado: ", skill_name)
	alvo.creature_dados.receber_dano(usuario.creature_dados.basic_attack.dano)

	if(has_knockback):
		var direcao := (alvo.global_position - usuario.global_position).normalized()
		alvo.apply_knockback(direcao * knockback_force, knockback_duration)

	#_spawn_attack_particle(usuario, alvo)
