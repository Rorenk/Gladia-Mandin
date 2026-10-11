extends Camera2D

var alvos: Array[Node2D] = []

@export var zoom_min: float = 1.0
@export var zoom_max: float = 1.35
@export var margem: Vector2 = Vector2(120, 100)
@export var suavizacao_pos: float = 6.0
@export var suavizacao_zoom: float = 4.0

func definir_alvos(lista: Array) -> void:
	alvos.clear()
	for a in lista:
		alvos.append(a)

func _process(delta: float) -> void:
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
	zoom_necessario = clampf(zoom_necessario, zoom_min, zoom_max)

	var z := lerpf(zoom.x, zoom_necessario, 1.0 - exp(-suavizacao_zoom * delta))
	zoom = Vector2(z, z)