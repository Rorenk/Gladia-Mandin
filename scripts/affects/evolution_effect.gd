extends Node2D
class_name EvolutionEffect

signal evolution_finished

@export_group("Tornado")
@export var tornado_height := 100.0
@export var radius_bottom := 20.0
@export var radius_top := 60.0

@export_group("Tempo (segundos)")
@export var leave_time := 3.0
@export_range(0.0, 1.0) var build_starts_at := 0.5
@export var build_time := 3.0
@export var flight_time := 0.6

var _sprite_particles: Array[Dictionary] = []
var _time := 0.0
var _pixel_size := 4.0
var _center := Vector2.ZERO

func play_evolution(pre_evolution_sprite: SpriteFrames, post_evolution_sprite: SpriteFrames, left_sprite: Vector2, right_sprite: Vector2, effect_center: Vector2, pixel_size := 4.0) -> void:
	_pixel_size = pixel_size
	_center = effect_center

	var extracted_pre := _extract(pre_evolution_sprite, left_sprite)
	var extracted_post := _extract(post_evolution_sprite, right_sprite)
	if extracted_pre.is_empty() or extracted_post.is_empty():
		evolution_finished.emit()
		return

	var bottom_first := func(a, b):
		if absf(a.position.y - b.position.y) > 0.01:
			return a.position.y > b.position.y
		return a.position.x < b.position.x
	var top_first := func(a, b):
		if absf(a.position.y - b.position.y) > 0.01:
			return a.position.y < b.position.y
		return a.position.x < b.position.x
	extracted_pre.sort_custom(bottom_first)
	extracted_post.sort_custom(top_first)

	_sprite_particles.clear()
	var total := maxi(extracted_pre.size(), extracted_post.size())
	var build_start := leave_time * build_starts_at
	var total_time := 0.0

	for i in total:
		var rank := float(i) / float(total)
		var pre_index := int(rank * extracted_pre.size())
		var post_index := int(rank * extracted_post.size())

		var leave := rank * leave_time + randf() * 0.1
		var build := maxf(build_start + rank * build_time, leave + flight_time)
		total_time = maxf(total_time, build + flight_time)

		_sprite_particles.append({
			"src": extracted_pre[pre_index].position,
			"dst": extracted_post[post_index].position,
			"c0": extracted_pre[pre_index].color,
			"c1": extracted_post[post_index].color,
			"ang": randf() * TAU,
			"spin": randf_range(0.6, 1.2),   
			"height": clampf(rank + randf_range(-0.1, 0.1), 0.0, 1.0),
			"radius_scale": randf_range(0.7, 1.0),
			"leave": leave,
			"build": build,
		})

	_time = 0.0
	var tween := create_tween()
	tween.tween_property(self, "_time", total_time, total_time)
	tween.finished.connect(func():
		_sprite_particles.clear()
		queue_redraw()
		evolution_finished.emit()
	)

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

func _tornado_point(particle: Dictionary, t: float) -> Vector2:
	var angle: float = particle.ang + t * particle.spin * TAU
	var radius: float = lerpf(radius_bottom, radius_top, particle.height) * particle.radius_scale
	var y: float = _center.y + tornado_height * 0.5 - particle.height * tornado_height
	return Vector2(_center.x + cos(angle) * radius, y + sin(angle) * radius * 0.3)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var t := _time
	for particle in _sprite_particles:
		var leave: float = particle.leave
		var build: float = particle.build
		var draw_position: Vector2

		if t < leave:                         
			draw_position = particle.src
		elif t < leave + flight_time:
			var k := ease((t - leave) / flight_time, 0.4)
			draw_position = particle.src.lerp(_tornado_point(particle, t), k)
		elif t < build:
			draw_position = _tornado_point(particle, t)
		elif t < build + flight_time:
			var k := ease((t - build) / flight_time, 2.0)
			draw_position = _tornado_point(particle, t).lerp(particle.dst, k)
		else:
			draw_position = particle.dst

		var color: Color = particle.c0.lerp(particle.c1, smoothstep(leave, build + flight_time, t))
		draw_rect(Rect2(draw_position, Vector2.ONE * _pixel_size), color)
