class_name MapaBase
extends Node2D

@export var limites: Rect2 = Rect2(0, 0, 640, 368)  

@onready var spawn_player: Marker2D = $SpawnPlayer
@onready var spawn_cpu: Marker2D = $SpawnCpu