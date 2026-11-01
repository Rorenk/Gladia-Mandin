extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card: Card = Card.new(load("uid://l56l266p286y"))
	add_child(card)
	card.position = Vector2(40, 57)
	#card.size = Vector2(32, 32)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
