extends Control

@onready var board_grid = $VBoxContainer/BoardGrid
@onready var popup = $PopupDialog
@onready var game_timer = $GameTimer
@onready var timer_label = $VBoxContainer/TimerLabel
@onready var map_selector_button = $VBoxContainer/MapSelectorOptionButton

const CellButton = preload("res://cellButton.tscn")
const BOARD_SIZE = 9

# --- Paletas de Colores Variadas para Cada Mapa ---

const MAP_0_COLORS: Array[Color] = [ # Originales / Base
	Color("#FF0000"), Color("#0000FF"), Color("#008000"), # Rojo, Azul, Verde
	Color("#FFFF00"), Color("#800080"), Color("#FFA500"), # Amarillo, Morado, Naranja
	Color("#FFC0CB"), Color("#00FFFF"), Color("#A52A2A")  # Rosa, Cian, Marrón
]

const MAP_1_COLORS: Array[Color] = [ # Más oscuros
	Color("#D90000"), Color("#0000D9"), Color("#006D00"),
	Color("#D9D900"), Color("#6D006D"), Color("#D98C00"),
	Color("#D9A3B0"), Color("#00D9D9"), Color("#8C2323")
]

const MAP_2_COLORS: Array[Color] = [ # Más claros
	Color("#FF3333"), Color("#3333FF"), Color("#339933"),
	Color("#FFFF33"), Color("#993399"), Color("#FFB833"),
	Color("#FFD9DF"), Color("#33FFFF"), Color("#BF5B5B")
]

const MAP_3_COLORS: Array[Color] = [ # Tonalidad desplazada / diferente saturación
	Color("#FF4500"), Color("#0040FF"), Color("#32CD32"), # RojoNaranja, AzulCasiVioleta, VerdeLima
	Color("#FFD700"), Color("#9400D3"), Color("#FF8C00"), # AmarilloOro, MoradoVioletaOscuro, NaranjaOscuro
	Color("#FF69B4"), Color("#40E0D0"), Color("#8B4513")  # RosaFuerte, Turquesa, MarrónSilla
]

const MAP_4_COLORS: Array[Color] = [ # Más Saturados / Intensos (o variaciones si ya son max)
	Color("#E00000"), Color("#0000E0"), Color("#007000"),
	Color("#E0E000"), Color("#700070"), Color("#E09400"),
	Color("#E0A8B5"), Color("#00E0E0"), Color("#942424")
]

const MAP_5_COLORS: Array[Color] = [ # Menos Saturados / Apagados
	Color("#FF6666"), Color("#6666FF"), Color("#66B266"),
	Color("#FFFF66"), Color("#B266B2"), Color("#FFCC66"),
	Color("#FFD1D9"), Color("#66FFFF"), Color("#C28080")
]

const MAP_6_COLORS: Array[Color] = [ # Mezcla 1
	Color("#C00000"), Color("#0000C0"), Color("#009900"), # Rojo osc, Azul osc, Verde vibrante
	Color("#FDFD00"), Color("#6A0DAD"), Color("#FF7F50"), # Amarillo brillante, Morado indigo, Naranja coral
	Color("#DB7093"), Color("#7FFFD4"), Color("#7B3F00")  # Rosa palo, Aguamarina, Marrón chocolate oscuro
]

const MAP_7_COLORS: Array[Color] = [ # Mezcla 2
	Color("#FA8072"), Color("#ADD8E6"), Color("#90EE90"), # Rojo salmón, Azul claro, Verde claro
	Color("#FFFACD"), Color("#DA70D6"), Color("#F4A460"), # Amarillo limónshiffon, Morado orquídea, Naranja arena
	Color("#FFB6C1"), Color("#AFEEEE"), Color("#D2B48C")  # Rosa claro, Turquesa pálido, Marrón tan
]

const MAP_8_COLORS: Array[Color] = [ # Mezcla 3
	Color("#8B0000"), Color("#00008B"), Color("#006400"), # Rojo oscuro, Azul oscuro, Verde oscuro
	Color("#FAFAD2"), Color("#E6E6FA"), Color("#FFDEAD"), # Amarillo cornsilk claro, Morado lavanda (pastel), Naranja navajo blanco
	Color("#FFDBE9"), Color("#E0FFFF"), Color("#BC8F8F")  # Rosa lavanda blush, Cian claro, Marrón rosybrown
]

const MAP_9_COLORS: Array[Color] = [ # Mezcla 4
	Color("#FF00FF"), Color("#00FF00"), Color("#1E90FF"), # Magenta, Lima, Azul dodger
	Color("#FFFFE0"), Color("#4B0082"), Color("#FF4500"), # Amarillo claro, Morado índigo, Naranja rojizo
	Color("#F08080"), Color("#20B2AA"), Color("#800000")  # Rosa coral claro, Cian verdoso (lightseagreen), Marrón oscuro (maroon)
]

const MAP_0_REGIONS = [
	[0,0,0,1,1,1,2,2,2],[0,0,0,1,1,1,2,2,2],[0,0,0,1,1,1,2,2,2],
	[3,3,3,4,4,4,5,5,5],[3,3,3,4,4,4,5,5,5],[3,3,3,4,4,4,5,5,5],
	[6,6,6,7,7,7,8,8,8],[6,6,6,7,7,7,8,8,8],[6,6,6,7,7,7,8,8,8],
]
const MAP_1_REGIONS = [
	[1,2,2,2,2,2,2,2,2],[1,2,2,2,2,2,2,2,3],[1,5,5,5,4,5,2,2,6],
	[1,5,5,5,5,5,5,6,6],[1,7,5,5,5,5,6,6,6],[7,7,7,7,5,6,6,6,6],
	[7,7,7,7,7,8,8,8,8],[7,7,7,7,7,8,8,8,8],[0,0,7,7,7,8,8,8,8],
]
const MAP_2_REGIONS = [
	[0,0,1,1,2,2,3,3,3],[0,0,1,1,2,2,3,4,3],[7,7,7,1,2,5,5,4,3],
	[7,6,7,8,8,8,5,4,3],[7,6,7,8,2,8,5,4,4],[7,6,6,8,2,2,5,4,4],
	[7,6,6,8,5,5,5,4,4],[7,6,6,8,8,8,8,4,4],[7,6,6,6,6,6,6,4,4],
]
const MAP_3_REGIONS = [
	[0,0,0,1,1,1,1,1,2],[0,0,0,1,1,1,2,2,2],[0,0,0,1,1,1,1,1,3],
	[0,0,0,0,6,4,4,4,3],[7,7,7,4,6,4,4,4,3],[7,7,8,4,4,4,4,4,4],
	[7,7,8,8,4,4,5,4,4],[7,8,8,8,8,4,4,4,4],[8,8,8,8,4,4,4,4,4],
]
const MAP_4_REGIONS = [
	[0,0,0,1,2,2,2,2,2],[1,0,0,1,3,3,3,3,3],[1,1,1,1,3,3,3,3,3],
	[1,1,1,1,3,3,3,3,3],[1,1,1,1,4,3,3,3,5],[1,1,6,6,6,5,5,5,5],
	[1,6,6,6,6,5,5,5,5],[6,6,6,6,6,6,5,5,8],[6,6,7,6,5,5,5,5,8],
]
const MAP_5_REGIONS = [
	[0,0,2,2,2,2,2,2,2],[1,0,2,2,2,2,2,2,2],[1,1,2,2,2,2,2,2,2],
	[1,2,2,2,3,2,2,2,2],[2,2,2,4,4,4,6,6,6],[2,2,2,4,4,4,6,6,6],
	[7,7,2,4,5,6,6,6,8],[7,7,7,5,5,5,5,5,8],[7,7,7,7,7,5,5,5,8],
]
const MAP_6_REGIONS = [
	[0,0,1,1,1,2,2,2,2],[0,1,1,1,1,2,2,2,2],[0,1,3,2,2,2,2,2,2],
	[3,3,3,2,2,2,2,6,2],[5,5,3,2,2,2,6,6,6],[5,5,4,2,2,7,7,7,7],
	[5,5,4,5,5,7,7,7,7],[5,5,5,5,5,7,8,7,7],[5,5,5,5,5,5,5,5,7],
]
const MAP_7_REGIONS = [
	[0,0,1,1,1,2,2,2,2],[0,3,3,3,1,4,4,4,2],[0,3,5,5,5,4,6,6,2],
	[0,3,5,7,7,7,6,6,2],[8,8,5,7,5,7,6,6,2],[8,5,5,5,7,7,6,6,6],
	[8,8,8,7,7,6,6,6,6],[8,8,8,7,7,7,6,6,6],[8,8,8,8,8,8,8,8,8],
]
const MAP_8_REGIONS = [
	[0,0,0,1,1,1,1,1,2],[0,0,0,1,1,1,2,2,2],[0,0,0,1,1,1,1,1,3],
	[0,0,0,0,4,5,5,5,3],[7,7,7,5,4,5,5,5,3],[7,7,8,5,5,5,5,5,5],
	[7,7,8,8,5,5,6,5,5],[7,8,8,8,8,5,5,5,5],[8,8,8,8,5,5,5,5,5],
]
const MAP_9_REGIONS = [
	[0,0,0,2,2,2,2,2,2],[0,1,1,2,2,2,2,2,2],[0,0,0,0,4,4,4,2,3],
	[0,0,0,0,4,4,0,5,3],[0,0,0,0,0,0,0,5,5],[0,0,0,0,0,0,0,5,5],
	[6,6,0,0,0,0,8,5,5],[6,6,0,0,0,0,8,8,8],[6,6,0,7,7,0,8,8,8],
]

const PREDEFINED_MAPS = [
	{"regions": MAP_0_REGIONS, "colors": MAP_0_COLORS, "name": "Mapa 1"},
	{"regions": MAP_1_REGIONS, "colors": MAP_1_COLORS, "name": "Mapa 2"},
	{"regions": MAP_2_REGIONS, "colors": MAP_2_COLORS, "name": "Mapa 3"},
	{"regions": MAP_3_REGIONS, "colors": MAP_3_COLORS, "name": "Mapa 4"},
	{"regions": MAP_4_REGIONS, "colors": MAP_4_COLORS, "name": "Mapa 5"},
	{"regions": MAP_5_REGIONS, "colors": MAP_5_COLORS, "name": "Mapa 6"},
	{"regions": MAP_6_REGIONS, "colors": MAP_6_COLORS, "name": "Mapa 7"},
	{"regions": MAP_7_REGIONS, "colors": MAP_7_COLORS, "name": "Mapa 8"},
	{"regions": MAP_8_REGIONS, "colors": MAP_8_COLORS, "name": "Mapa 9"},
	{"regions": MAP_9_REGIONS, "colors": MAP_9_COLORS, "name": "Mapa 10"}
]

var current_map_index := 0
var current_region_map: Array
var current_region_colors: Array[Color]

var elapsed_time := 0
var game_finished := false


func _ready():
	$Fondo.play("default")
	$AnimatedSprite2D.play("text")
	
	if PREDEFINED_MAPS.is_empty():
		show_error("¡No hay mapas predefinidos cargados!")
		return

	map_selector_button.clear()
	for i in PREDEFINED_MAPS.size():
		map_selector_button.add_item(PREDEFINED_MAPS[i]["name"], i)
	
	# Inicializar estado del juego y cargar el primer mapa
	load_map(0)
	map_selector_button.select(current_map_index)


func load_map(map_index: int):
	if map_index < 0 or map_index >= PREDEFINED_MAPS.size():
		printerr("Índice de mapa inválido: ", map_index, ". Cargando el primer mapa.")
		current_map_index = 0
	else:
		current_map_index = map_index

	var map_data: Dictionary = PREDEFINED_MAPS[current_map_index]
	
	current_region_map = map_data["regions"]
	current_region_colors = map_data["colors"]

	for child in board_grid.get_children():
		child.queue_free()

	for r in BOARD_SIZE: # Iterar por filas (x)
		for c in BOARD_SIZE: # Iterar por columnas (y)
			var cell = CellButton.instantiate()
			
			# Comprobación robusta de límites
			if not current_region_map or r < 0 or r >= current_region_map.size() or \
			   not current_region_map[r] or c < 0 or c >= current_region_map[r].size():
				printerr("Error: Coordenadas (%s, %s) o mapa de regiones inválido." % [r,c])
				continue

			var region_id = current_region_map[r][c]
			
			if not current_region_colors or region_id < 0 or region_id >= current_region_colors.size():
				printerr("Error: region_id %s inválido para el array de colores (tamaño: %s) en celda (%s, %s)" % [region_id, current_region_colors.size() if current_region_colors else "N/A", r,c])
				# Establecer un color de error visible si falla la asignación de color
				var stylebox = StyleBoxFlat.new()
				stylebox.bg_color = Color.MAGENTA 
				cell.add_theme_stylebox_override("normal", stylebox)
				cell.add_theme_stylebox_override("hover", stylebox)
				cell.add_theme_stylebox_override("pressed", stylebox)
				cell.add_theme_stylebox_override("disabled", stylebox)
			else:
				# Usar StyleBoxFlat para cambiar el color de fondo del botón
				var stylebox = StyleBoxFlat.new()
				stylebox.bg_color = current_region_colors[region_id]
				# Aplicar a todos los estados relevantes para consistencia visual
				cell.add_theme_stylebox_override("normal", stylebox)
				cell.add_theme_stylebox_override("hover", stylebox.duplicate()) # Podrías querer variaciones para hover/pressed
				cell.get_theme_stylebox("hover", "Button").bg_color = current_region_colors[region_id].lightened(0.1)
				cell.add_theme_stylebox_override("pressed", stylebox.duplicate())
				cell.get_theme_stylebox("pressed", "Button").bg_color = current_region_colors[region_id].darkened(0.1)
				cell.add_theme_stylebox_override("disabled", stylebox.duplicate())
				cell.get_theme_stylebox("disabled", "Button").bg_color = Color(current_region_colors[region_id], 0.5) # Semi-transparente


			cell.set_coordinates(r, c) # Asegúrate que set_coordinates tome (fila, columna)
			if cell.has_method("set_state"):
				cell.set_state(0) # Estado inicial EMPTY
			cell.set_disabled(false) # Las celdas nuevas están habilitadas
			cell.connect("first_click_detected",Callable(self,"_on_first_cell_click")) # Asegúrate que la señal sea correcta
			board_grid.add_child(cell)
	
	# Reiniciar estado del juego para el nuevo mapa / o al inicio
	elapsed_time = 0
	timer_label.text = format_time(elapsed_time) # Mostrar "00:00 s"
	game_timer.stop()
	game_finished = false


func _on_map_selected(index: int):
	if index != current_map_index:
		load_map(index)

func _on_first_cell_click():
	# Iniciar el temporizador solo si está detenido Y el juego no ha terminado.
	# elapsed_time se reinicia solo en load_map.
	if game_timer.is_stopped() and not game_finished:
		game_timer.start()

func _on_game_timer_timeout():
	if not game_finished: # Solo incrementar si el juego no ha terminado
		elapsed_time += 1
		timer_label.text = format_time(elapsed_time)

func format_time(seconds: int) -> String:
	var minutes = seconds / 60
	var secs = seconds % 60
	return "%02d:%02d s" % [minutes, secs]

func _on_validar_pressed():
	validate_board()

func _on_reset_button_pressed():
	var game_was_won = game_finished
	for i in board_grid.get_child_count():
		var cell = board_grid.get_child(i)
		if cell is Button and cell.has_method("set_state"):
			cell.set_state(0) 
			cell.set_disabled(false)
			 
	game_finished = false 
	
	if game_was_won:
		elapsed_time = 0
		timer_label.text = format_time(elapsed_time) 
		game_timer.stop() 
	# else:
		# Si el juego estaba en curso (o no había comenzado),
		# no se toca elapsed_time ni el estado de game_timer.
		# El temporizador continúa como estaba.


func validate_board():
	var crown_positions = []

	for r in BOARD_SIZE:
		for c in BOARD_SIZE:
			var cell_index = r * BOARD_SIZE + c
			if cell_index >= board_grid.get_child_count():
				printerr("Índice de celda fuera de rango en validate_board")
				continue
			var cell = board_grid.get_child(cell_index)
			if not (cell is Button and cell.has_method("get_state")):
				continue

			match cell.get_state():
				1: 
					crown_positions.append(Vector2i(r, c))
				# 2:  # BLOCKED (Si necesitas lógica para celdas bloqueadas, aquí iría)
				#	blocked_positions.append(Vector2i(r, c))


	if crown_positions.size() != BOARD_SIZE: # Usar BOARD_SIZE dinámicamente
		show_error("Debe haber exactamente %d coronas." % BOARD_SIZE)
		return

	var filas = {}
	var columnas = {}
	var regiones_color = {}

	for pos in crown_positions:
		if filas.has(pos.x):
			show_error("Dos coronas en la misma fila (%d)." % (pos.x + 1))
			return
		if columnas.has(pos.y):
			show_error("Dos coronas en la misma columna (%d)." % (pos.y + 1))
			return

		if pos.x < 0 or pos.x >= BOARD_SIZE or pos.y < 0 or pos.y >= BOARD_SIZE or \
		   not current_region_map or pos.x >= current_region_map.size() or \
		   not current_region_map[pos.x] or pos.y >= current_region_map[pos.x].size():
			show_error("Error interno: Posición de corona (%s, %s) o mapa de regiones inválido." % [pos.x, pos.y])
			return
			
		var region_id = current_region_map[pos.x][pos.y]
		if regiones_color.has(region_id):
			show_error("Dos coronas en la misma región de color (Región ID: %d)." % region_id)
			return

		# Verificar cercanía (diagonales y adyacentes) con otras coronas ya validadas
		for other_pos in crown_positions:
			if pos == other_pos:
				continue # No comparar consigo misma
			if abs(pos.x - other_pos.x) <= 1 and abs(pos.y - other_pos.y) <= 1:
				show_error("Dos coronas en (%s,%s) y (%s,%s) están demasiado cerca." % [pos.x+1, pos.y+1, other_pos.x+1, other_pos.y+1])
				return

		filas[pos.x] = true
		columnas[pos.y] = true
		regiones_color[region_id] = true

	show_message("¡Solución válida!\nTiempo: %s" % format_time(elapsed_time))
	game_timer.stop()
	game_finished = true

	# Deshabilitar tablero
	for i in board_grid.get_child_count():
		var cell = board_grid.get_child(i)
		if cell is Button and cell.has_method("set_disabled"):
			cell.set_disabled(true)

func show_error(msg):
	popup.dialog_text = "❌ " + msg
	popup.popup_centered()

func show_message(msg):
	popup.dialog_text = "✅ " + msg
	popup.popup_centered()
