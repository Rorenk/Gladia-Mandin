extends Camera2D

var alvos: Array[Node2D] = []

var zoom_min: float = 1.0
@export var zoom_extra: float = 0.35
@export var margem: Vector2 = Vector2(120, 100)
@export var suavizacao_pos: float = 6.0
@export var suavizacao_zoom: float = 4.0
var modo_manual: bool = false

func definir_mapa(limites: Rect2) -> void:
	limit_left = int(limites.position.x)
	limit_top = int(limites.position.y)
	limit_right = int(limites.end.x)
	limit_bottom = int(limites.end.y)

	var tela := get_viewport_rect().size
	zoom_min = maxf(tela.x / limites.size.x, tela.y / limites.size.y)
	zoom = Vector2(zoom_min, zoom_min)

func definir_alvos(lista: Array) -> void:
	alvos.clear()
	for a in lista:
		alvos.append(a)

func _process(delta: float) -> void:
	if modo_manual:
		return
	alvos = alvos.filter(func(a): return is_instance_valid(a))
	if alvos.is_empty():
		return

	var rect := Rect2(alvos[0].global_position, Vector2.ZERO)
	for a in alvos:
		rect = rect.expand(a.global_position)
	rect = rect.grow_individual(margem.x, margem.y, margem.x, margem.y)

	global_position = global_position.lerp(rect.get_center(), 1.0 - exp(-suavizacao_pos * delta))

	var tela := get_viewport_rect().size
	var zoom_necessario := minf(tela.x / rect.size.x, tela.y / rect.size.y)
	zoom_necessario = clampf(zoom_necessario, zoom_min, zoom_min * (1.0 + zoom_extra))

	var z := lerpf(zoom.x, zoom_necessario, 1.0 - exp(-suavizacao_zoom * delta))
	zoom = Vector2(z, z)

func focar(pos: Vector2, zoom_alvo: float, duracao: float) -> void:
	modo_manual = true
	var t := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "global_position", pos, duracao)
	t.tween_property(self, "zoom", Vector2(zoom_alvo, zoom_alvo), duracao)
	await t.finished

func liberar() -> void:
	modo_manual = false