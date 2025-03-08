extends Node2D

@onready var sprite = $Sprite
var move_speed = Vector2(16, 16)
var fall_time = 1.0
var fall_timer = 0.0
var can_move = true
var grid_position = Vector2i()  # Posición de la pieza en la grilla
@onready var grid: TileMap = $"../Grid"


func _ready():
	position_gems()
	
func _process(delta):
	fall_timer += delta
	if fall_timer >= fall_time:
		fall_timer = 0.0
		move_down()
	
func move_left():
	if can_move:
		position.x -= move_speed.x
		if position.x<=24:
			$Sprite.frame=4
			position.x=24

func move_right():
	if can_move:
		position.x += move_speed.x
		if position.x>=104:
			$Sprite.frame=2
			position.x=104
func move_down():
	
	var grid_pos = grid.world_to_grid(position)
	grid_pos.y += 1  # Simulamos la caída

	# Verificamos si hay algo abajo o si toca el suelo
	if grid_pos.y > 13 or get_parent().grid.get_gem(grid_pos) != -1:
		grid_pos.y -= 1  # Revertimos el movimiento para que no atraviese
		position = get_parent().grid.grid_to_world(grid_pos)  # Ajustamos a la grilla
		set_process(false)  # 🔥 Desactivamos _process para que la pieza ya no siga moviéndose
		return  # Salimos de la función

	# Si no ha tocado el suelo, seguimos moviendo la pieza
	position = get_parent().grid.grid_to_world(grid_pos)
	check_collision()
		
	
	

func drop_faster():
	move_down()

func rotate_piece():
	# Cambiar la posición de las gemas dentro de la pieza
	pass

func check_collision():
	if not can_move:
		return

	var grid_pos = get_parent().grid.world_to_grid(position + Vector2(0, 16))  # Posición debajo

	# Si la pieza llegó al suelo o toca otra gema
	if grid_pos.y > 13 or get_parent().grid.get_gem(grid_pos) != -1:
		can_move = false  # Bloqueamos la caída

		# Forzar alineación en la grilla
		var final_grid_pos = get_parent().grid.world_to_grid(position)
		final_grid_pos.y = min(final_grid_pos.y, 13)  # Evitar que pase de la fila 12
		position = get_parent().grid.grid_to_world(final_grid_pos)

		print("Posición FINAL en grilla después de ajuste:", final_grid_pos)  # Debug
		$Sprite.frame=6
		get_parent().place_gems_in_grid(self)
		get_parent().spawn_new_piece()
		
func position_gems():
	var gem_positions = [Vector2(0, 0), Vector2(0, -16), Vector2(0, -32)]
	var gems = [$Gem1, $Gem2, $Gem3]  # Acceder directamente a las gemas

	for i in range(3):
		var gem = gems[i]
		gem.position = gem_positions[i]  # Ajustar la posición en la pieza
		
func set_gem_types(types: Array):
	var gems = [$Gem1, $Gem2, $Gem3]
	for i in range(3):
		gems[i].gem_type = types[i]
		
