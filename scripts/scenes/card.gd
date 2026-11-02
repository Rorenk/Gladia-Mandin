class_name Card
extends Node2D

@export var card_stats: CardResource

func _init(card_stats: CardResource = null) -> void:
	self.card_stats = card_stats

var card_frame: TextureRect = TextureRect.new()
var card_art: TextureRect = TextureRect.new()	

var card_title: Label = Label.new()
var card_description: RichTextLabel = RichTextLabel.new()
var card_price: Label = Label.new()

func create_visuals() -> void:
	card_frame.texture = card_stats.card_frame
	card_art.texture = card_stats.card_art
	
	add_child(card_frame)
	add_child(card_art)
	
	card_art.position = Vector2(14, 12)
	card_art.size = Vector2(32, 32)
	
	card_title.text = card_stats.card_name
	card_description.text = card_stats.card_description
	
	add_child(card_title)
	add_child(card_description)
	
	card_title.position = Vector2(54, 12)
	card_title.size = Vector2(32, 32)
	
	card_description.position = Vector2(128, 12)
	card_description.size = Vector2(128, 128)
	
	card_price.text = str(card_stats.card_price)
	
	add_child(card_price)
	
	card_price.position = Vector2(54, 35)
	card_price.size = Vector2(32, 32)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_visuals()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
