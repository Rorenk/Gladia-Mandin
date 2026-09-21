class_name AttackBase
extends Resource

@export var hitbox_shape: Shape2D
@export var skill_name: String
@export var cooldown: float
@export var has_knockback: bool
@export var skill_description: String
@export var skill_icon: Texture2D
@export var attack_particle: PackedScene
@export var hitbox_duration: float = 0.15


#func _spawn_attack_particle(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
#	if attack_particle == null:
#		return
#	var efeito := attack_particle.instantiate()
#	usuario.get_parent().add_child(efeito)
#	efeito.global_position = usuario.global_position.lerp(alvo.global_position, 0.5)
	
