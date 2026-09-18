extends Node

@onready var basic_attack_timer: Timer = $CreatureBasicAttackTimer
@onready var skill_timer: Timer = $CreatureSkillTimer

func inicializar(skill: SkillBase, attack: AttackBase) -> void:
	skill_timer.one_shot = true
	basic_attack_timer.one_shot = true
	skill_timer.start(skill.cooldown)
	basic_attack_timer.start(attack.cooldown)

func can_use_basic_attack() -> bool:
	return basic_attack_timer.is_stopped()

func use_basic_attack(attack: AttackBase, usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	if not can_use_basic_attack(): return
	attack.executar(usuario, alvo)
	basic_attack_timer.start(attack.cooldown)


func can_use_skill() -> bool:
		return skill_timer.is_stopped()

func use_skill(skill: SkillBase, usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	if not can_use_skill(): return
	skill.executar(usuario, alvo)
	skill_timer.start(skill.cooldown)
