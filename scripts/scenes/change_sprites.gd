extends Sprite2D

@export var textura_normal: Texture2D
@export var textura_hover: Texture2D
@export var texto_hover: String = ""

@onready var label: Label = $Label

var criatura_em_cima: Node2D = null

func _ready() -> void:
	texture = textura_normal
	label.text = texto_hover
	label.visible = false

func _process(_delta: float) -> void:
	var segurando: bool = false
	if criatura_em_cima != null:
		segurando = bool(criatura_em_cima.get_meta("sendo_arrastado", false))

	texture = textura_hover if segurando else textura_normal
	label.visible = segurando

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("_carregar_creature_data"):
		criatura_em_cima = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == criatura_em_cima:
		criatura_em_cima = null
		
func tem_criatura_em_cima() -> bool:
	return criatura_em_cima != null

func posicao_prender() -> Vector2:
	return $Area2D.global_position
