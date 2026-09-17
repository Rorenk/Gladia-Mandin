extends Node2D

@onready var basic_attack_timer: Timer = $CreatureBasicAttackTimer
@onready var skill_timer: Timer = $CreatureSkillTimer


func can_use_basic_attack() -> bool:
	return basic_attack_timer.is_stopped()

func use_basic_attack(attack, usuario, alvo, ) -> void:
	if not can_use_basic_attack(): return
	attack.executar(usuario, alvo)
	basic_attack_timer.start(attack.cooldown)


func can_use_skill() -> bool:
		return skill_timer.is_stopped()

func use_skill(skill, usuario, alvo, ) -> void:
	if not can_use_skill(): return
	skill.executar(usuario.alvo)
	skill_timer.start(skill.cooldown)


