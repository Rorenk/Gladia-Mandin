extends SkillBase
class_name SkillTeste


func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
    print("Skill usada: ", skill_name) 
    print("Cooldown: ", cooldown)
    print("Cliquei em ", usuario.creature_dados.creature_name)

