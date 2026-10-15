extends SkillBase
class_name SkillTeste
const ALCANCE := 60.0

const CAMINHO_CENA_BOING := "res://scenes/boing_drop.tscn"
const NOME_OVERLAY := "BoingOverlay"
const CAMADA_OVERLAY := 100   # acima do mundo e da câmera da batalha

func executar(usuario: CreatureBattleTemplate, alvo: CreatureBattleTemplate) -> bool:
	if usuario.global_position.distance_to(alvo.global_position) > ALCANCE:
		return false

	# O attack_manager só chama executar() quando o cooldown da skill chegou a zero
	# (e o alvo está no alcance), então este é o momento de mostrar a cena por cima.
	#_mostrar_boing()

	#print("Skill usada: ", skill_name) 
	#print("Cooldown: ", cooldown)
	#print("Cliquei em ", usuario.creature_dados.creature_name)
	#print("velocidade atual: ", usuario.creature_dados.creature_speed)
	#print("descrição da skill: ", skill_description)
	#print("hp atual", usuario.creature_dados.creature_current_hp)
	print("hp maximo: ", usuario.creature_dados.creature_max_hp)
	print("hp atual: ", usuario.creature_dados.creature_current_hp)
	#usuario.creature_dados.creature_speed = usuario.creature_dados.creature_speed - 10
	return true


# Coloca a cena boing_drop num CanvasLayer por cima da batalha. A luta continua
# rodando no fundo (nada é pausado). Se o overlay já existe, só derruba de novo.
func _mostrar_boing() -> void:
	var arvore := Engine.get_main_loop() as SceneTree
	if arvore == null or arvore.current_scene == null:
		return

	var overlay := arvore.current_scene.get_node_or_null(NOME_OVERLAY) as CanvasLayer
	if overlay != null:
		var cena_existente := overlay.get_child(0)
		if cena_existente.has_method("derrubar"):
			cena_existente.call("derrubar")
		return

	var pacote := load(CAMINHO_CENA_BOING) as PackedScene
	if pacote == null:
		push_warning("SkillTeste: não foi possível carregar " + CAMINHO_CENA_BOING)
		return

	overlay = CanvasLayer.new()
	overlay.name = NOME_OVERLAY
	overlay.layer = CAMADA_OVERLAY

	var cena: Node = pacote.instantiate()
	cena.set("reiniciar_com_input", false)   # cliques da batalha não reiniciam a queda
	overlay.add_child(cena)
	arvore.current_scene.add_child(overlay)
