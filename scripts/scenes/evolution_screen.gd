extends Node2D

@export var criatura_pre: CreatureResource
@export var criatura_pos: CreatureResource

@onready var effect: EvolutionEffect = $EvolutionEffect
@onready var texto: Label = $TextoEvolucao
@export var tempo_por_letra := 0.17
const FONTE_ANUNCIO: Font = preload("res://assets/sprites/effects/fonteff.png")

@export var tamanho_fonte := 24
func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	texto.add_theme_font_override("font", FONTE_ANUNCIO)
	texto.add_theme_font_size_override("font_size", tamanho_fonte)
	_escrever(texto, ("%s esta mudando..." % criatura_pre.creature_name).to_upper())
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


func _escrever(label: Label, texto_novo: String) -> void:
	label.text = texto_novo
	label.visible_ratio = 0.0
	var duracao := texto_novo.length() * tempo_por_letra
	create_tween().tween_property(label, "visible_ratio", 1.0, duracao)