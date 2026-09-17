extends Resource
class_name CreatureResource

#tipos de ataque de criatura para serem modificados diretamente no inspetor

var creature_affection: int = 0
var creature_current_hp: int

@export var special_skill: SkillBase

@export var creature_sprite_sheet: SpriteFrames
@export var creature_name: String
@export var creature_max_hp: int
@export var creature_attack: int
@export var creature_defense: int 
@export var creature_special_attack: int
@export var creature_special_defense: int
@export var creature_speed: int
@export var creature_luck: int
@export var creature_form: int


func _init() -> void:
    creature_current_hp = creature_max_hp

func receber_dano(quantidade: int) -> void:
    creature_current_hp = max(0, creature_current_hp - quantidade)

func curar(quantidade: int) -> void:
    creature_current_hp = min(creature_max_hp, creature_current_hp + quantidade)

func receber_afeito(quantidade: int) -> void:
    creature_affection = clamp(creature_affection + quantidade, -100, 100) 