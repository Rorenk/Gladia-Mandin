extends Area2D
class_name AttackHitbox


var damage: int
var already_hit: Array = []
var knockback_direction := Vector2.ZERO
var knockback_force := 0.0
var knockback_duration := 0.0

func hitbox_config(shape: Shape2D, dano: int, duration: float) -> void:
	$CollisionShape2D.shape = shape
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

	



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
