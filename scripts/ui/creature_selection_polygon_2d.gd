extends Polygon2D

@export var radius: float = 170.0
@export var points: int = 64

func _ready():
	var polygon_points = PackedVector2Array()

	for i in range(points):
		var angle = TAU * i / points
		var point = Vector2(cos(angle), sin(angle)) * radius
		polygon_points.append(point)

	polygon = polygon_points

	position = get_viewport_rect().size / 2