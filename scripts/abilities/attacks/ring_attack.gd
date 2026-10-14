extends AttackBase
class_name RingAttack

@export var damage: int
@export var attack_range: float
@export var knockback_force: float
@export var knockback_duration: float
@export var speed := 75
var BLUE = Color(0, 0, 1, 1)
var CYAN = Color(0, 1, 1, 1)
var GREEN = Color(0, 1, 0, 1)
var YELLOW = Color(1, 1, 0, 1)
var ORANGE = Color(1, 0.64705884, 0, 1)
var RED = Color(1, 0, 0, 1)
var MAGENTA = Color(1, 0, 1, 1)
var vetor_de_cores : PackedColorArray

const HITBOX_SCENE = preload("res://scenes/attack_hitbox.tscn")

func atacar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> bool:
	var distancia := usuario.global_position.distance_to(alvo.global_position)
	if distancia > attack_range:
		return false
		
	print("Ataque usado: ", skill_name)

	var direction := (usuario.alvo.global_position - usuario.global_position).normalized()
	
	var hitbox = HITBOX_SCENE.instantiate()
	hitbox.attack_texture = attack_texture
	hitbox.hit_particle = attack_particle
	usuario.get_parent().add_child(hitbox)
	var offset: float = min(distancia, attack_range)
	hitbox.global_position = usuario.global_position + direction
	hitbox.velocity = direction * speed 
	hitbox.collision_layer = 0
	hitbox.collision_mask = usuario.inimigos_mask

	if has_knockback:
		hitbox.knockback_direction = direction
		hitbox.knockback_force = knockback_force
		hitbox.knockback_duration = knockback_duration

	hitbox.hitbox_config(hitbox_shape, damage, hitbox_duration, attack_texture)
	return true


	
	
	
