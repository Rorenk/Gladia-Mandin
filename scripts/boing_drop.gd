extends Node2D
## Cena de teste: as creatures caem de cima da tela e fazem "boing" ao tocar o chão.
## Aperte ESPAÇO / ENTER ou clique para derrubá-las de novo.

const FLOOR_Y := 360.0           # borda inferior da câmera (viewport 640x360)
const GRAVITY := 1500.0          # px/s²
const RESTITUTION := 0.45        # quanto da velocidade volta a cada quique
const MIN_BOUNCE_SPEED := 110.0  # abaixo disso a creature assenta
const BASE_SCALE := 3.0          # sprites 32x32 ampliados para ficarem visíveis
const START_Y := -80.0           # acima da tela
const STAGGER := 0.35            # atraso entre uma creature e outra

## Quando a cena é usada como overlay (ex.: pela skill), desligue para que
## cliques/ENTER da batalha não reiniciem a queda.
@export var reiniciar_com_input := true

@onready var creatures: Array[Sprite2D] = [
	$Anjo, $Fumiga, $Cebolita, $MaisCriativomon
]

var _state: Array[Dictionary] = []


func _ready() -> void:
	_drop_all()


## Derruba todas as creatures de novo (uso público, ex.: chamado pela skill).
func derrubar() -> void:
	_drop_all()


func _unhandled_input(event: InputEvent) -> void:
	if not reiniciar_com_input:
		return
	var clicked: bool = event is InputEventMouseButton and event.pressed
	if event.is_action_pressed("ui_accept") or clicked:
		_drop_all()


func _drop_all() -> void:
	for s in _state:
		if s.tween and s.tween.is_valid():
			s.tween.kill()
	_state.clear()
	for i in creatures.size():
		var spr := creatures[i]
		spr.position.y = START_Y
		spr.scale = Vector2.ONE * BASE_SCALE
		_state.append({
			"node": spr,
			"vy": 0.0,
			"delay": i * STAGGER,
			"settled": false,
			"squashing": false,
			"tween": null,
		})


func _process(delta: float) -> void:
	for s in _state:
		if s.settled:
			continue
		s.delay -= delta
		if s.delay > 0.0:
			continue

		var spr: Sprite2D = s.node
		s.vy += GRAVITY * delta
		spr.position.y += s.vy * delta

		# Esticada leve na queda, proporcional à velocidade.
		if not s.squashing and s.vy > 0.0:
			var k := clampf(s.vy / 2500.0, 0.0, 0.18)
			spr.scale = Vector2(1.0 - k * 0.6, 1.0 + k) * BASE_SCALE

		if spr.position.y >= FLOOR_Y:
			spr.position.y = FLOOR_Y
			var impact: float = s.vy
			if impact > MIN_BOUNCE_SPEED:
				_boing(s, impact)
				s.vy = -impact * RESTITUTION
			else:
				s.vy = 0.0
				s.settled = true
				spr.scale = Vector2.ONE * BASE_SCALE


func _boing(s: Dictionary, impact: float) -> void:
	var spr: Sprite2D = s.node
	var force := clampf(impact / 900.0, 0.15, 1.0)
	var squash := Vector2(1.0 + 0.45 * force, 1.0 - 0.45 * force) * BASE_SCALE

	if s.tween and s.tween.is_valid():
		s.tween.kill()
	s.squashing = true
	var tw := create_tween()
	s.tween = tw
	# Achata rápido no impacto...
	tw.tween_property(spr, "scale", squash, 0.06).set_ease(Tween.EASE_OUT)
	# ...e volta com uma mola elástica: o "boing".
	tw.tween_property(spr, "scale", Vector2.ONE * BASE_SCALE, 0.6) \
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tw.finished.connect(func(): s.squashing = false)
