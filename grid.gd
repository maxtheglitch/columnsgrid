extends TileMap

var tile_size = Vector2i(16, 16)  # Tamaño de cada celda
var grid_size = Vector2i(6, 13)   # Tamaño total del tablero (6x13)
var tile_layer = 0  # Capa del TileMap donde se dibujan las gemas
@onready var gem: Node2D = $"../Gem"


# 📌 Coloca una gema en la cuadrícula
func place_gem(grid_position: Vector2i, gem_id: int):
	set_cell(tile_layer, grid_position, 1, Vector2i(gem_id, 0))  # Coloca la gema con su ID

# 📌 Obtiene la gema en una posición de la cuadrícula
func get_gem(grid_position: Vector2i) -> int:
	return get_cell_atlas_coords(tile_layer, grid_position).x  # Devuelve el ID de la gema

# 📌 Borra una gema de la cuadrícula
func remove_gem(grid_position: Vector2i):
	set_cell(tile_layer, grid_position, -1)  # -1 significa celda vacía

# 📌 Convierte coordenadas de mundo a cuadrícula
func world_to_grid(world_position: Vector2) -> Vector2i:
	return local_to_map(world_position)

# 📌 Convierte coordenadas de cuadrícula a mundo
func grid_to_world(grid_position: Vector2i) -> Vector2:
	return map_to_local(grid_position)
