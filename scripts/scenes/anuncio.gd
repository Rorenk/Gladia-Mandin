class_name AnuncioCreature
extends CanvasLayer

@export var fonte: Font
@export var tamanho_fonte: int = 24
@export var cor_fundo: Color = Color(0, 0, 0, 0.75)
@export var cor_borda: Color = Color(1, 0.85, 0.2)
@export var margem_lateral: float = 32.0
@export var y_jogador: float = 0.72
@export var y_inimigo: float = 0.20

const LARGURA := 280.0
const ALTURA := 72.0

func mostrar(nome: String, textura: Texture2D, esquerda: bool) -> void:
	var tela := get_viewport().get_visible_rect().size

	var painel := PanelContainer.new()
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = cor_fundo
	estilo.border_color = cor_borda
	estilo.set_border_width_all(2)
	estilo.set_corner_radius_all(6)
	estilo.set_content_margin_all(8)
	painel.add_theme_stylebox_override("panel", estilo)

	var linha := HBoxContainer.new()
	linha.add_theme_constant_override("separation", 10)
	painel.add_child(linha)

	var img := TextureRect.new()
	img.texture = textura
	img.custom_minimum_size = Vector2(56, 56)
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST  # pixel art nítida

	var label := Label.new()
	label.text = nome.to_upper()
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if fonte:
		label.add_theme_font_override("font", fonte)
	label.add_theme_font_size_override("font_size", tamanho_fonte)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 4)

	if esquerda:
		linha.add_child(img)
		linha.add_child(label)
	else:
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		linha.add_child(label)
		linha.add_child(img)

	add_child(painel)
	painel.size = Vector2(LARGURA, ALTURA)

	var y := tela.y * (y_jogador if esquerda else y_inimigo)
	var x_dentro := margem_lateral if esquerda else tela.x - LARGURA - margem_lateral
	var x_fora := -LARGURA - 20.0 if esquerda else tela.x + 20.0
	painel.position = Vector2(x_fora, y)

	var t := create_tween()
	t.tween_property(painel, "position:x", x_dentro, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_interval(1.2)
	t.tween_property(painel, "position:x", x_fora, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await t.finished
	painel.queue_free()
	
func mostrar_ready_fight(textura: Texture2D) -> void:
	var tela := get_viewport().get_visible_rect().size

	var raiz := Control.new()
	raiz.set_anchors_preset(Control.PRESET_FULL_RECT)
	raiz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(raiz)

	# sprite do lado esquerdo
	var img := TextureRect.new()
	img.texture = textura
	img.custom_minimum_size = Vector2(160, 160)
	img.size = Vector2(160, 160)
	img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var y_img := tela.y * 0.5 - 80.0
	var x_img := 24.0
	img.position = Vector2(-200.0, y_img)
	raiz.add_child(img)

	# texto central
	var label := Label.new()
	label.size = Vector2(tela.x, 90)
	label.position = Vector2(0, tela.y * 0.5 - 45.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if fonte:
		label.add_theme_font_override("font", fonte)
	label.add_theme_font_size_override("font_size", tamanho_fonte * 2)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 8)
	label.pivot_offset = label.size / 2.0
	label.scale = Vector2.ZERO
	label.text = "READY?"
	raiz.add_child(label)

	# sprite entra
	var t1 := create_tween()
	t1.tween_property(img, "position:x", x_img, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# READY? aparece
	var t2 := create_tween()
	t2.tween_property(label, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await t2.finished
	await get_tree().create_timer(0.8).timeout

	# FIGHT! aparece (maior e amarelo)
	label.text = "FIGHT!"
	label.add_theme_color_override("font_color", cor_borda)
	label.scale = Vector2(1.6, 1.6)
	var t3 := create_tween()
	t3.tween_property(label, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await t3.finished

	# some em segundo plano, sem segurar a luta
	var t4 := create_tween().set_parallel(true)
	t4.tween_property(raiz, "modulate:a", 0.0, 0.4).set_delay(0.5)
	t4.tween_property(img, "position:x", -200.0, 0.4).set_delay(0.5)
	t4.chain().tween_callback(raiz.queue_free)
