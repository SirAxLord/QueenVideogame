extends Button

enum State { EMPTY, CROWN, BLOCKED }
var coordinates := Vector2i.ZERO
var current_state: State = State.EMPTY

signal first_click_detected

var clicked_once := false

func _ready():
	update_visual()

func _gui_input(event: InputEvent):
	if disabled: 
		return
		
	if event is InputEventMouseButton and event.pressed:
		if not clicked_once:
			clicked_once = true
			first_click_detected.emit()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_state == State.EMPTY:
				set_state(State.CROWN)
			elif current_state == State.CROWN:
				set_state(State.BLOCKED)
			else: # BLOCKED
				set_state(State.EMPTY)

func set_state(new_state: State):
	current_state = new_state
	update_visual()

func get_state() -> State:
	return current_state

func update_visual():
	match current_state:
		State.EMPTY:
			text = ""
			icon = null
		State.CROWN:
			text = ""
			text = "👑" 
		State.BLOCKED:
			text = "" 
			text = "❌"

func set_coordinates(x: int, y: int):
	coordinates = Vector2i(x, y)
	set_state(State.EMPTY) 

func set_theme_color(color: Color):
	var style_normal = get_theme_stylebox("normal", "Button").duplicate(true) if has_theme_stylebox("normal", "Button") else StyleBoxFlat.new()
	var style_hover = get_theme_stylebox("hover", "Button").duplicate(true) if has_theme_stylebox("hover", "Button") else StyleBoxFlat.new()
	var style_pressed = get_theme_stylebox("pressed", "Button").duplicate(true) if has_theme_stylebox("pressed", "Button") else StyleBoxFlat.new()
	var style_disabled = get_theme_stylebox("disabled", "Button").duplicate(true) if has_theme_stylebox("disabled", "Button") else StyleBoxFlat.new()

	if style_normal is StyleBoxFlat:
		style_normal.bg_color = color
	if style_hover is StyleBoxFlat:
		style_hover.bg_color = color.lightened(0.2)
	if style_pressed is StyleBoxFlat:
		style_pressed.bg_color = color.darkened(0.2) 
	if style_disabled is StyleBoxFlat:
		style_disabled.bg_color = color.darkened(0.4)
		
	add_theme_stylebox_override("normal", style_normal)
	add_theme_stylebox_override("hover", style_hover)
	add_theme_stylebox_override("pressed", style_pressed)
	add_theme_stylebox_override("disabled", style_disabled)


func _notification(what):
	if what == NOTIFICATION_VISIBILITY_CHANGED or what == NOTIFICATION_ENTER_TREE or what == NOTIFICATION_EXIT_TREE:
		return 
	
	if what == NOTIFICATION_READY: # O podrías usar _ready()
		pass # _ready se encarga de update_visual inicial
