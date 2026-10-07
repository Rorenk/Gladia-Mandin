extends Node2D


@export var criatura_pre: CreatureResource
@export var criatura_pos: CreatureResource

@onready var effect: EvolutionEffect = $EvolutionEffect

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	evoluir(criatura_pre.creature_sprite_sheet, criatura_pos.creature_sprite_sheet)

func evoluir(pre: SpriteFrames, post: SpriteFrames) -> void:
	$PreEvolutionSprite2D.sprite_frames = pre
	$PosEvolutionSprite2D.sprite_frames = post
	$PreEvolutionSprite2D.hide()
	$PosEvolutionSprite2D.hide()

	var centro: Vector2 = ($PreEvolutionSprite2D.global_position + $PosEvolutionSprite2D.global_position) / 2.0
	var pixel_size: float = $PosEvolutionSprite2D.scale.x

	effect.play_evolution(
		pre, post,
		effect.to_local($PreEvolutionSprite2D.global_position),
		effect.to_local($PosEvolutionSprite2D.global_position),
		effect.to_local(centro),
		pixel_size
	)
	await effect.evolution_finished


	$PosEvolutionSprite2D.show()
	$PosEvolutionSprite2D.play("idle")
