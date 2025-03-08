extends Node2D

@onready var grid: TileMap = $Grid

var gem_sequence = [[0,0,0], [0,0,1], [0,0,2], [0,0,3], [0,0,4], [0,0,5], [0,1,1], [0,1,2], [0,1,3], [0,1,4], [0,1,5], [0,2,2], [0,2,3], [0,2,4], [0,2,5], [0,3,3], [0,3,4], [0,3,5], [0,4,4], [0,4,5], [0,5,5], [1,1,1], [1,1,2], [1,1,3], [1,1,4], [1,1,5], [1,2,2], [1,2,3], [1,2,4], [1,2,5], [1,3,3], [1,3,4], [1,3,5], [1,4,4], [1,4,5], [1,5,5], [2,2,2], [2,2,3], [2,2,4], [2,2,5], [2,3,3], [2,3,4], [2,3,5], [2,4,4], [2,4,5], [2,5,5], [3,3,3], [3,3,4], [3,3,5], [3,4,4], [3,4,5], [3,5,5], [4,4,4], [4,4,5], [4,5,5], [5,5,5]] # Secuencia basada en Columns de Sega
var current_index = 0  # Índice actual en la secuencia
var columns_original_order = [16, 13, 43, 25, 49, 22, 49, 34, 9, 16, 1, 34, 24, 9, 14, 45, 14, 19, 36, 19, 9, 19, 22, 40, 13, 25, 20, 27, 28, 9, 28, 7, 53, 24, 34, 9, 36, 22, 37, 14, 40, 39, 44, 13, 41, 45, 19, 27, 28, 49, 50, 38, 43, 34, 9, 28, 0, 2, 3, 4, 5, 6, 8, 10, 11, 12, 15, 17, 18, 21, 23, 26, 29, 30, 31, 32, 33, 35, 37, 38, 39, 41, 44, 42, 46, 47, 48, 51, 52, 53, 54, 55]
@onready var spawner = $PieceSpawner
@onready var ui = $UI

var piece_scene = preload("res://scenes/Piece.tscn")
var Gem = preload("res://scenes/Gem.tscn")

var current_piece = null
var grid_size = Vector2i(6, 13)  # 6x13 casillas

func _ready():
	start_new_game()

func start_new_game():
	clear_grid()
	spawn_new_piece()

func spawn_new_piece():
	if current_piece and current_piece.can_move:
		return
	
	current_piece = piece_scene.instantiate()
	current_index = columns_original_order[0]
	var pattern = gem_sequence[current_index]  # Obtener el siguiente patrón de gemas
	current_piece.set_gem_types(pattern)
	
	current_index = current_index % gem_sequence.size()  # Avanzar en la secuencia
	columns_original_order[0]+=1
	var grid_pos = Vector2i(4, 1)  # Reiniciar posición en la cuadrícula
	current_piece.grid_position = grid_pos
	current_piece.position = grid.map_to_local(grid_pos)

	current_piece.z_index = -1  # Asegurar que aparece por debajo del mapa
	
	add_child(current_piece)

func _process(delta):
	if current_piece:
		handle_input()

func handle_input():
	if Input.is_action_just_pressed("ui_left"):
		current_piece.move_left()
	elif Input.is_action_just_pressed("ui_right"):
		current_piece.move_right()
	elif Input.is_action_just_pressed("ui_down"):
		current_piece.drop_faster()
	elif Input.is_action_just_pressed("ui_accept"):
		current_piece.rotate_piece()

func place_gems_in_grid(piece):
	for gem in piece.get_children():
		print("Posición en grilla antes:", grid.world_to_grid(gem.global_position))
		if not gem.has_method("check_neighbors"):  
			continue  # Ignora nodos que no sean gemas

		var grid_pos = grid.world_to_grid(gem.global_position)  
		
		# Evitar que una gema se salga de la cuadrícula
		grid_pos.y = min(grid_pos.y, 13)  

		gem.grid_position = grid_pos  
		gem.global_position = grid.map_to_local(grid_pos)  

		grid.set_cell(0, grid_pos, 1, Vector2i(gem.gem_type, 0))  

	check_matches()  # Verifica combinaciones

func check_matches():
	# Implementar la lógica para buscar combinaciones de 3+ gemas iguales
	pass

func clear_grid():
	var grid_size = Vector2i(6, 13)  # Tamaño de la cuadrícula
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			grid.set_cell(0, Vector2i(x, y), -1)  # -1 borra la celda
