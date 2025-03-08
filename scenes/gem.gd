extends Node2D

@export var gem_type: int = 0  # Diferentes tipos de gemas
@onready var sprite = $Sprite2D
var grid_position: Vector2i  # Posición en la cuadrícula

func _ready():
	sprite.frame = gem_type  # Usa una animación con los colores de las gemas

func check_neighbors():
	# Verificar si hay 3+ gemas del mismo color alrededor
	pass
