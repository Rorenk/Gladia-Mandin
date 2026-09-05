extends AnimatedSprite2D
class_name CreatureSelectionTemplate

var velocidade := 15.0
var direcao := Vector2.ZERO
var trocar_direcao_timer := 0.0
var pode_andar := true
var centro_circulo := Vector2(320, 180)
var raio_circulo := 150.0 
var escala_base := 1.0 
var tempo_animacao := 0.0 
var intensidade_squash := 0.15 
var velocidade_squash := 8.0

func _ready() -> void:
	_sortear_nova_direcao()

func _on_creature_template_area_2d_mouse_entered() -> void:
	frame = 1;
	pode_andar = false


func _on_creature_template_area_2d_mouse_exited() -> void:
	frame = 0;
	pode_andar = true

func _process(delta: float) -> void:
	if not pode_andar:
		scale = Vector2.ONE * escala_base 
		return

	position += direcao * velocidade * delta

	if direcao.x < 0:
		flip_h = true
	elif direcao.x > 0:
		flip_h = false

	tempo_animacao += delta * velocidade_squash
	var onda = sin(tempo_animacao)
	scale.x = escala_base * (1.0 + onda * intensidade_squash)
	scale.y = escala_base * (1.0 - onda * intensidade_squash)


	var distancia = position.distance_to(centro_circulo)
	if distancia > raio_circulo:
		direcao = (centro_circulo - position).normalized()

	trocar_direcao_timer -= delta
	if trocar_direcao_timer <= 0:
		_sortear_nova_direcao()

func _sortear_nova_direcao() -> void:
	var angulo := randf_range(0, TAU)
	direcao = Vector2(cos(angulo), sin(angulo))
	trocar_direcao_timer = randf_range(2, 5)
