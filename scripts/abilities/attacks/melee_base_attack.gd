extends AttackBase
class_name MeleeBaseAttack

@export var damage: int
@export var attack_range: float
@export var knockback_force: float
@export var knockback_duration: float

const HITBOX_SCENE = preload("res://scenes/attack_hitbox.tscn")

func atacar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	var distancia := usuario.global_position.distance_to(alvo.global_position)
	if distancia > attack_range:
		return
		
	print("Ataque usado: ", skill_name)

	var direction := (usuario.alvo.global_position - usuario.global_position).normalized()

	var hitbox = HITBOX_SCENE.instantiate()
	usuario.get_parent().add_child(hitbox)
	var offset: float = min(distancia, attack_range)
	hitbox.global_position = usuario.global_position + direction * offset
	hitbox.collision_layer = 0
	hitbox.collision_mask = usuario.inimigos_mask

	if has_knockback:
		hitbox.knockback_direction = direction
		hitbox.knockback_force = knockback_force
		hitbox.knockback_duration = knockback_duration

	hitbox.hitbox_config(hitbox_shape, damage, hitbox_duration)

	#_spawn_attack_particle(usuario, alvo)
