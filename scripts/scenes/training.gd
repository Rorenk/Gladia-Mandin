extends Node2D

#Camera e limite de mapa
@export var velocidade_camera: float = 300.0
@export var margem_borda: float = 60.0
@export var limite_esquerdo: float = 0.0
@export var limite_direito: float = 3000.0

#Centro do passeio do mandinho (para onde ele volta ao bater na parede)
var centro_passeio: Vector2

#Estados de animacao e do arrasto
var tempo_animacao := 0.0
var arrastando := false

#Ficar preso em áreas especificas
var preso := false
@onready var livro: Sprite2D = $BackgroundPT1

#Efeito de Profundidade, Achatamento e quando arrasta eles
@export var y_longe: float = 250.0
@export var y_perto: float = 650.0
@export var escala_longe: float = 0.4
@export var escala_perto: float = 1.0

@export var intensidade_squash: float = 0.15
@export var velocidade_squash: float = 8.0
@export var intensidade_achatamento: float = 0.3
@export var velocidade_transicao_escala: float = 12.0

func _ready() -> void:
	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))

	var tamanho_tela := get_viewport().get_visible_rect().size
	$Camera2D.position = Vector2(limite_esquerdo + tamanho_tela.x / 2.0, tamanho_tela.y / 2.0)
	$CreaturePlayerUm.set_physics_process(false)

	# O centro do passeio é onde o mandinho nasce
	centro_passeio = $CreaturePlayerUm.global_position

func _process(delta: float) -> void:
	_mover_camera(delta)

func _physics_process(delta: float) -> void:
	if arrastando:
		_arrastar_criatura(delta)
	elif preso:
		_manter_presa(delta)
	else:
		_mover_criatura(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not $CreaturePlayerUm.pode_andar:
				arrastando = true
				preso = false
				$CreaturePlayerUm.set_meta("sendo_arrastado", true)
		else:
			# Se soltar o mandinho dentro da área ela fica presa
			if arrastando and livro.tem_criatura_em_cima():
				preso = true
				$CreaturePlayerUm.global_position = livro.posicao_prender()
				$CreaturePlayerUm.velocity = Vector2.ZERO
			arrastando = false
			$CreaturePlayerUm.set_meta("sendo_arrastado", false)

# Segurando o mandinho
func _arrastar_criatura(delta: float) -> void:
	var destino := get_global_mouse_position()
	destino.x = clampf(destino.x, limite_esquerdo, limite_direito)
	$CreaturePlayerUm.global_position = destino
	$CreaturePlayerUm.velocity = Vector2.ZERO

	tempo_animacao += delta * velocidade_squash
	var onda: float = sin(tempo_animacao)
	var escala_achatada := Vector2(
		_escala_atual() * (1.0 + intensidade_achatamento + onda * intensidade_squash),
		_escala_atual() * (1.0 - intensidade_achatamento - onda * intensidade_squash)
	)
	$CreaturePlayerUm.scale = $CreaturePlayerUm.scale.lerp(escala_achatada, clampf(delta * velocidade_transicao_escala, 0.0, 1.0))

# Mandinho andando
func _mover_criatura(delta: float) -> void:
	if not $CreaturePlayerUm.pode_andar:
		$CreaturePlayerUm.scale = $CreaturePlayerUm.scale.lerp(Vector2.ONE * _escala_atual(), clampf(delta * velocidade_transicao_escala, 0.0, 1.0))
		return

	$CreaturePlayerUm.velocity = $CreaturePlayerUm.direcao * $CreaturePlayerUm.creature_dados.creature_speed

	if $CreaturePlayerUm.direcao.x < 0:
		$CreaturePlayerUm.sprite.flip_h = true
	elif $CreaturePlayerUm.direcao.x > 0:
		$CreaturePlayerUm.sprite.flip_h = false

	# Animacao de "squash"
	tempo_animacao += delta * velocidade_squash
	var onda: float = sin(tempo_animacao)
	var escala_squash := Vector2(
		_escala_atual() * (1.0 + onda * intensidade_squash),
		_escala_atual() * (1.0 - onda * intensidade_squash)
	)
	$CreaturePlayerUm.scale = $CreaturePlayerUm.scale.lerp(escala_squash, clampf(delta * velocidade_transicao_escala, 0.0, 1.0))

	$CreaturePlayerUm.trocar_direcao_timer -= delta
	if $CreaturePlayerUm.trocar_direcao_timer <= 0:
		$CreaturePlayerUm._sortear_nova_direcao()

	$CreaturePlayerUm.move_and_slide()

	# Se bater em uma parede (grupo "limite") volta pro centro
	_checar_paredes()

# Colisao com as paredes do passeio
func _checar_paredes() -> void:
	for i in $CreaturePlayerUm.get_slide_collision_count():
		var colisao: KinematicCollision2D = $CreaturePlayerUm.get_slide_collision(i)
		var objeto := colisao.get_collider() as Node
		if objeto != null and objeto.is_in_group("limite"):
			$CreaturePlayerUm.direcao = (centro_passeio - $CreaturePlayerUm.global_position).normalized()
			break

# Mandinho preso na área
func _manter_presa(delta: float) -> void:
	$CreaturePlayerUm.velocity = Vector2.ZERO
	$CreaturePlayerUm.global_position = livro.posicao_prender()
	$CreaturePlayerUm.scale = $CreaturePlayerUm.scale.lerp(
		Vector2.ONE * _escala_atual(),
		clampf(delta * velocidade_transicao_escala, 0.0, 1.0)
	)

# Camera
func _mover_camera(delta: float) -> void:
	var viewport := get_viewport()
	var largura := viewport.get_visible_rect().size.x
	var mouse_x := viewport.get_mouse_position().x

	var direcao := 0.0
	if mouse_x < margem_borda:
		direcao = -1.0
	elif mouse_x > largura - margem_borda:
		direcao = 1.0

	if direcao == 0.0:
		return

	var x_min := limite_esquerdo + largura / 2.0
	var x_max := limite_direito - largura / 2.0
	$Camera2D.position.x = clampf($Camera2D.position.x + direcao * velocidade_camera * delta, x_min, x_max)

# Efeito de Profundidade
func _fator_profundidade() -> float:
	var t := clampf(inverse_lerp(y_longe, y_perto, $CreaturePlayerUm.global_position.y), 0.0, 1.0)
	return lerpf(escala_longe, escala_perto, t)

func _escala_atual() -> float:
	return $CreaturePlayerUm.escala_base * _fator_profundidade()
