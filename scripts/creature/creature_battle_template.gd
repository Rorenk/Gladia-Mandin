extends CharacterBody2D
class_name CreatureBattleTemplate

@onready var sprite: AnimatedSprite2D = $CreatureBattleTemplateAnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $CreatureNavigationAgent2D
@onready var life_bar: ProgressBar = $CreatureProgressBar
@onready var attack_manager: Node = $CreatureAttackManager

@export var hop_altura := 6.0
@export var hop_distancia := 40.0
@export var hop_squash := 0.08
@export var hop_velocidade := 2.0



var direcao := Vector2.ZERO
var trocar_direcao_timer := 0.0
var escala_base := 0.6
var pode_andar := true
var creature_dados: CreatureResource
var alvo: CreatureBattleTemplate
var is_in_knockback := false
var inimigos_mask := 0
var _hop_fase := 0.0
var _sprite_pos_base := Vector2.ZERO
var _sprite_scale_base := Vector2.ONE


func _carregar_creature_data(dados: CreatureResource) -> void:
	creature_dados = dados
	creature_dados.inicializar()
	creature_dados.hp_changed.connect(update_life_bar)
	attack_manager.inicializar(creature_dados.special_skill, creature_dados.basic_attack)
	sprite.sprite_frames = dados.creature_sprite_sheet
	print("Criatura carregada: ", creature_dados.creature_name)
	update_life_bar()


func update_life_bar() -> void:
		life_bar.max_value = creature_dados.creature_max_hp
		life_bar.value = creature_dados.creature_current_hp


func _ready() -> void:
	_sprite_pos_base = sprite.position
	_sprite_scale_base = sprite.scale
	_sortear_nova_direcao()

func _on_creature_battle_template_area_2d_mouse_entered() -> void:
	sprite.frame = 1
	pode_andar = false


func _on_creature_battle_template_area_2d_mouse_exited() -> void:
	sprite.frame = 0
	pode_andar = true


func apply_knockback(force: Vector2, duration: float) -> void:
	is_in_knockback = true
	var vel = force
	var tempo_restante = duration

	while tempo_restante > 0.0:
		var delta = get_process_delta_time()
		velocity = vel
		move_and_slide()
		vel = vel.move_toward(Vector2.ZERO, vel.length() / tempo_restante * delta)
		tempo_restante -= delta
		await get_tree().physics_frame

		velocity = Vector2.ZERO
		is_in_knockback = false

func _process(delta: float) -> void:
	_atualizar_pulinho(delta)

func _physics_process(delta: float) -> void:
	if is_in_knockback: return
	scale = Vector2.ONE * escala_base
	if  alvo == null:
		return
	
	attack_manager.use_skill(creature_dados.special_skill, self, alvo)
	attack_manager.use_basic_attack(creature_dados.basic_attack, self, alvo)
	

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



func definir_time(meu_time: int, times_inimigos: Array) -> void:
	collision_layer = 0
	set_collision_layer_value(meu_time, true)
	collision_mask = 1
	inimigos_mask = 1
	for t in times_inimigos:
		set_collision_mask_value(t, true)
		inimigos_mask |= 1 << (t - 1)
		
		
		
func _atualizar_pulinho(delta: float) -> void:
	var vel := 0.0
	if alvo != null and not is_in_knockback:
		vel = velocity.length()

	if vel > 5.0:
		# a fase avança pela distância percorrida, não pelo tempo
		_hop_fase = fmod(_hop_fase + vel * hop_velocidade * delta / hop_distancia, 1.0)
		var hop := sin(_hop_fase * PI)   # 0 → 1 → 0 a cada pulinho
		sprite.position.y = _sprite_pos_base.y - hop * hop_altura
		var s := hop_squash * (hop - 0.5) * 2.0   # estica no ar, achata ao pousar
		sprite.scale = Vector2(_sprite_scale_base.x * (1.0 - s * 0.5), _sprite_scale_base.y * (1.0 + s))
	else:
		# parado: volta suavemente ao repouso
		_hop_fase = 0.0
		var t := 1.0 - exp(-12.0 * delta)
		sprite.position = sprite.position.lerp(_sprite_pos_base, t)
		sprite.scale = sprite.scale.lerp(_sprite_scale_base, t)
