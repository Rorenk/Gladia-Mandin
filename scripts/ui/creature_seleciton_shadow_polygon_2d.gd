extends Polygon2D

@export var radius: float = 180.0
@export var points: int = 64

func _ready():
	var polygon_points = PackedVector2Array()

	for i in range(points):
		var angle = TAU * i / points
		var point = Vector2(cos(angle), sin(angle)) * radius
		polygon_points.append(point)

	polygon = polygon_points

	
	var gradiente := Gradient.new()
	gradiente.set_color(0, Color(1, 1, 1, 1))
	gradiente.set_color(1, Color(0, 0, 0, 1))

	var textura_gradiente := GradientTexture2D.new()
	textura_gradiente.gradient = gradiente
	textura_gradiente.fill = GradientTexture2D.FILL_RADIAL
	textura_gradiente.fill_from = Vector2(0.5, 0.5)
	textura_gradiente.fill_to = Vector2(1.0, 0.5) 
	textura_gradiente.width = int(radius * 2)
	textura_gradiente.height = int(radius * 2)

	texture = textura_gradiente
	texture_offset = Vector2(-radius, -radius) 


	var material_multiply := CanvasItemMaterial.new()
	material_multiply.blend_mode = CanvasItemMaterial.BLEND_MODE_MUL
	material = material_multiply