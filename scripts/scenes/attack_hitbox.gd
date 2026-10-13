extends Area2D
class_name AttackHitbox


var damage: int
var already_hit: Array = []
var knockback_direction := Vector2.ZERO
var knockback_force := 0.0
var knockback_duration := 0.0
var velocity := Vector2.ZERO
var destroy_on_hit := true
#var particula_de_ataque = preload("res://scenes/particula_explosao.tscn")
var hit_particle : PackedScene

func hitbox_config(shape: Shape2D, dano: int, duration: float) -> void:
	$AttackHitboxCollision.shape = shape
	damage = dano
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(duration).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is CreatureBattleTemplate and not body in already_hit:
		already_hit.append(body)
		body.creature_dados.receber_dano(damage)
		if knockback_force > 0:
			body.apply_knockback(knockback_direction * knockback_force, knockback_duration)
		_spawn_attack_particle(global_position)
		if destroy_on_hit == true:
			queue_free()

func _process(delta):
	global_position += velocity * delta
	
func _spawn_attack_particle(posicao: Vector2):
	if hit_particle == null: return
	var efeito: Node = hit_particle.instantiate()
	get_parent().add_child(efeito)
	efeito.global_position = posicao
	var particulas: CPUParticles2D = efeito.get_node("CPUParticles2D")
	particulas.finished.connect(efeito.queue_free)
	particulas.emitting = true
