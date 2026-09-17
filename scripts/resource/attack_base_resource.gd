class_name AttackBase
extends Resource

@export var skill_name: String
@export var cooldown: float
@export var skill_description: String
@export var skill_icon: Texture2D
@export var has_knockback: bool


func executar(usuario, alvo) -> void:
	pass