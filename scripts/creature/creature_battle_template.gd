extends CharacterBody2D
class_name CreatureBattleTemplate

@onready var sprite: AnimatedSprite2D = $CreatureBattleTemplateAnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $CreatureNavigationAgent2D

var direcao := Vector2.ZERO
var trocar_direcao_timer := 0.0
var pode_andar := true
var intensidade_squash := 0.15 
var velocidade_squash := 8.0
var creature_dados: CreatureResource
var alvo: CreatureBattleTemplate

func _carregar_creature_data(dados: CreatureResource) -> void:
	creature_dados = dados
	sprite.sprite_frames = dados.creature_sprite_sheet
	print("Criatura carregada: ", creature_dados.creature_name)


func _ready() -> void:
	_sortear_nova_direcao()

func _on_creature_battle_template_area_2d_mouse_entered() -> void:
	sprite.frame = 1
	pode_andar = false


func _on_creature_battle_template_area_2d_mouse_exited() -> void:
	sprite.frame = 0
	pode_andar = true

func _physics_process(delta: float) -> void:
	if  alvo == null:
		return
	
	nav_agent.target_position = alvo.global_position

	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var proximo_ponto := nav_agent.get_next_path_position()
	var direcao_nav = (proximo_ponto - global_position).normalized()
	velocity = direcao_nav * creature_dados.creature_speed

	if direcao_nav.x < 0:
		sprite.flip_h = true
	elif direcao_nav.x > 0:
		sprite.flip_h = false



	move_and_slide()


	
func _sortear_nova_direcao() -> void:
	var angulo := randf_range(0, TAU)
	direcao = Vector2(cos(angulo), sin(angulo))
	trocar_direcao_timer = randf_range(2, 5)
