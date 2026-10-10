extends Node2D

signal evolution_finished

var _sprite_particles: Array[Dictionary] = []
var _evolution_progress := 0.0
var _pixel_size := 4.0
var _center := Vector2.ZERO

#pre_evolution_sprite e post_evolution_sprite são os sprites antes e depois da evolução
#left_sprite e right_sprite localização dos spirtes na tela
#effect_center localização do efeito 
#pixel_size e duration são respectivamente o tamanho do pixel e a duração da animação
func play_evolution(pre_evolution_sprite: SpriteFrames, post_evolution_sprite: SpriteFrames, left_sprite: Vector2, right_sprite: Vector2, effect_center: Vector2, pixel_size := 4.0, duration := 3.0) -> void:
	_pixel_size = pixel_size
	_center = effect_center

#extrai os pixels dos sprites para desfragmentar e remontalos
	var extracted_pre := _extract(pre_evolution_sprite, left_sprite)
	var extracted_post := _extract(post_evolution_sprite, right_sprite)
	var by_luminance := func(m, n): return m.color.get_luminance() < n.color.get_luminance()
	extracted_pre.sort_custom(by_luminance)
	extracted_post.sort_custom(by_luminance)

	_sprite_particles.clear()
	
	if extracted_pre.is_empty() or extracted_post.is_empty():
		evolution_finished.emit()
		return

	var total := maxi(extracted_pre.size(), extracted_post.size())
	for i in total:
		var pre_index := int(i * float(extracted_pre.size()) / float(total))
		var post_index := int(i * float(extracted_post.size()) / float(total))
		_sprite_particles.append({
			"src": extracted_pre[pre_index].position, "dst": extracted_post[post_index].position,
			"c0": extracted_pre[pre_index].color, "c1": extracted_post[post_index].color,
			"ang": randf() * TAU,
			"rad": randf_range(10.0, 90.0),
			"spin": randf_range(1.5, 3.0),
			"delay": randf() * 0.3,
		})
	_evolution_progress = 0.0
	var tween_progress := create_tween()
	tween_progress.tween_property(self, "_evolution_progress", 1.0, duration)
	tween_progress.finished.connect(func(): evolution_finished.emit())




func _extract(sprite: SpriteFrames, sprite_location: Vector2) -> Array:
	var animation: StringName = sprite.get_animation_names()[0]
	var image := sprite.get_frame_texture(animation, 0).get_image()
	if image.is_compressed():
		image.decompress()

	var half := Vector2(image.get_size()) * _pixel_size * 0.5
	var out := []

	for y in image.get_height():
		for x in image.get_width():
			var color := image.get_pixel(x, y)
			if color.a > 0.1:
				out.append({
					"position": sprite_location - half + Vector2(x, y) * _pixel_size,
					"color": color,
				})
	return out

func _orbit(particle: Dictionary, progress: float) -> Vector2:
	var angle: float = particle.ang + progress * particle.spin * TAU
	var radius: float = particle.rad * (1.0 - 0.3 * sin(progress * PI))
	return _center + Vector2.from_angle(angle) * radius

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for particle in _sprite_particles:
		var progress := clampf((_evolution_progress - particle.delay) / 0.7, 0.0, 1.0)
		var position: Vector2

		if progress < 0.3:      # 1) desfaz o sprite e vai pro vórtice
			position = particle.src.lerp(_orbit(particle, progress), ease(progress / 0.3, 0.4))
		elif progress < 0.7:    # 2) gira no vórtice
			position = _orbit(particle, progress)
		else:                   # 3) reconstrói no sprite da direita
			position = _orbit(particle, progress).lerp(particle.dst, ease((progress - 0.7) / 0.3, 2.0))

		var color: Color = particle.c0.lerp(particle.c1, smoothstep(0.25, 0.75, progress))
		draw_rect(Rect2(position, Vector2.ONE * _pixel_size), color)





