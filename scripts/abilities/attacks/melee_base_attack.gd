extends AttackBase
class_name MeleeBaseAttack


func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	print("Skill usada: ", skill_name) 
	print("Cooldown: ", cooldown)
	print("Cliquei em ", usuario.creature_dados.creature_name)
	print("velocidade atual: ", usuario.creature_dados.creature_speed)
	print("descrição da skill: ", skill_description)
	print("hp atual", usuario.creature_dados.creature_current_hp)
	print("hp maximo", usuario.creature_dados.creature_max_hp)
	usuario.creature_dados.creature_speed = usuario.creature_dados.creature_speed - 10