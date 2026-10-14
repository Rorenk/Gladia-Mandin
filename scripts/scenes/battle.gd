extends Node2D

const FONTE_ANUNCIO: Font = null
const SHEET_FUMIGA: Texture2D = preload("res://assets/sprites/creatures/fumiga.png")	
const FUMIGA_LARGURA := 64
const FUMIGA_ALTURA := 64
const FUMIGA_INDICE := 0
const time_player : int = 2
const time_cpu : int = 3
const MAPAS := {
	"floresta": preload("res://scenes/forest_map.tscn"),
	#"gelo": preload("res://scenes/ice_map.tscn"),
}

func _ready() -> void:
	var chave: String = MAPAS.keys().pick_random()
	var mapa: MapaBase = MAPAS[chave].instantiate()
	add_child(mapa)
	move_child(mapa, 0)
	await get_tree().physics_frame

	$CreaturePlayerUm.global_position = mapa.spawn_player.global_position
	$CreatureCpuUm.global_position = mapa.spawn_cpu.global_position

	$CreaturePlayerUm._carregar_creature_data(GameState.creature_escolhida.duplicate(true))
	$CreatureCpuUm._carregar_creature_data(_sortear_creature_cpu().duplicate(true))
	$CreaturePlayerUm.alvo = $CreatureCpuUm
	$CreatureCpuUm.alvo = $CreaturePlayerUm
	$CreaturePlayerUm.definir_time(time_player, [time_cpu])
	$CreatureCpuUm.definir_time(time_cpu, [time_player])

	$Camera2D.definir_mapa(mapa.limites)
	$Camera2D.definir_alvos([$CreaturePlayerUm, $CreatureCpuUm])

	var anuncio := AnuncioCreature.new()
	anuncio.fonte = FONTE_ANUNCIO
	anuncio.y_jogador = 0.7
	anuncio.y_inimigo = 0.1
	add_child(anuncio)	
	await _intro(mapa, anuncio)

func _intro(mapa: MapaBase, anuncio: AnuncioCreature) -> void:
	var cam: Camera2D = $Camera2D
	var player: CreatureBattleTemplate = $CreaturePlayerUm
	var cpu: CreatureBattleTemplate = $CreatureCpuUm
	var centro: Vector2 = mapa.limites.get_center()
	var dados: CreatureResource = player.creature_dados
	var dados_cpu: CreatureResource = cpu.creature_dados
	var textura: Texture2D = _textura_creature(dados)
	var textura_cpu: Texture2D = _textura_creature(dados_cpu)

	for c in [player, cpu]:
		c.visible = false
		c.process_mode = Node.PROCESS_MODE_DISABLED

	cam.modo_manual = true
	cam.global_position = centro
	cam.zoom = Vector2(cam.zoom_min, cam.zoom_min)
	var zoom_foco: float = cam.zoom_min * 1.4

	await get_tree().create_timer(0.6).timeout
	await cam.focar(player.global_position, zoom_foco, 0.9)
	await _spawnar(player)
	anuncio.mostrar(dados.creature_name, textura, true)
	await get_tree().create_timer(1.4).timeout

	await cam.focar(cpu.global_position, zoom_foco, 0.9)
	await _spawnar(cpu)
	anuncio.mostrar(dados_cpu.creature_name, textura_cpu, false)
	await get_tree().create_timer(1.4).timeout

	await cam.focar(centro, cam.zoom_min, 0.9)
	var sprite_fumiga := _frame_do_sheet(SHEET_FUMIGA, FUMIGA_LARGURA, FUMIGA_ALTURA, FUMIGA_INDICE)
	await anuncio.mostrar_ready_fight(sprite_fumiga)
	cam.liberar()
	for c in [player, cpu]:
		c.process_mode = Node.PROCESS_MODE_INHERIT

func _spawnar(c: Node2D) -> void:
	var escala_original: Vector2 = c.scale
	c.scale = Vector2.ZERO
	c.visible = true
	var t := create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	t.tween_property(c, "scale", escala_original, 0.5)
	await t.finished

func _textura_creature(dados: CreatureResource) -> Texture2D:
	var frames: SpriteFrames = dados.creature_sprite_sheet
	if frames == null:
		return null
	var anim: StringName = &"idle"
	if not frames.has_animation(anim):
		var nomes := frames.get_animation_names()
		if nomes.is_empty():
			return null
		anim = nomes[0]
	return frames.get_frame_texture(anim, 0)

func _frame_do_sheet(sheet: Texture2D, largura: int, altura: int, indice: int) -> Texture2D:
	if sheet == null:
		return null
	var colunas := maxi(1, sheet.get_width() / largura)
	var atlas := AtlasTexture.new()
	atlas.atlas = sheet
	atlas.region = Rect2(
		(indice % colunas) * largura,
		floori(float(indice) / colunas) * altura,
		largura,
		altura
	)
	return atlas

func _sortear_creature_cpu() -> CreatureResource:
	var escolhida: CreatureResource = GameState.creature_escolhida
	var candidatas: Array[CreatureResource] = []

	for arquivo in DirAccess.get_files_at("res://resources/creatures/"):
		if not arquivo.ends_with(".tres"):
			continue
		var c: CreatureResource = load("res://resources/creatures/" + arquivo)
		if c.creature_name == escolhida.creature_name:
			continue
		if c.creature_form != escolhida.creature_form:
			continue
		candidatas.append(c)

	if candidatas.is_empty():
		return escolhida
	return candidatas.pick_random()