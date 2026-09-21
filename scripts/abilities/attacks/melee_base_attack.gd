extends AttackBase
class_name MeleeBaseAttack

@export var dano: int
@export var alcance: float
@export var knockback_force: float
@export var knockback_duration: float

const HITBOX_SCENE = preload("res://scenes/attack_hitbox.tscn")

func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> void:
	print("Ataque usado: ", skill_name)
	var direction := (usuario.alvo.global_position - usuario.global_position).normalized()

	var hitbox = HITBOX_SCENE.instantiate()
	usuario.get_parent().add_child(hitbox)
	hitbox.global_position = usuario.global_position + direction * alcance


	if has_knockback:
		hitbox.knockback_direcao = direcao
		hitbox.knockback_force = knockback_force
		hitbox.knockback_duration = knockback_duration

	hitbox.hitbox_cofig(hitbox_shape, dano, hitbox_duration)

	#_spawn_attack_particle(usuario, alvo)
