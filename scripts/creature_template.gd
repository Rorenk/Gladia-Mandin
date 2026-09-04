extends AnimatedSprite2D
class_name CreatureTemplate


func _on_creature_template_area_2d_mouse_entered() -> void:
	print("Mouse entrou:")
	frame = 1;


func _on_creature_template_area_2d_mouse_exited() -> void:
	print("Mouse saiu:")
	frame = 0;
