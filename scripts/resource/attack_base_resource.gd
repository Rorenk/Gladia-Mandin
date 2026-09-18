class_name AttackBase
extends Resource

@export var skill_name: String
@export var cooldown: float
@export var has_knockback: bool
@export var skill_description: String
@export var skill_icon: Texture2D


func executar(usuario, alvo) -> void:
	pass

#func _spawn_attack_particle(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
#	if attack_particle == null:
#		return
#	var efeito := attack_particle.instantiate()
#	usuario.get_parent().add_child(efeito)
#	efeito.global_position = usuario.global_position.lerp(alvo.global_position, 0.5)