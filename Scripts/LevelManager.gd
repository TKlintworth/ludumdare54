extends Node2D

@export var alive_enemies : int
@export var selectable_tiles : int
@export var level_UI : Control
@export var tile_map : TileMap

var num_tiles_selected = 0
var num_tiles_remaining
var num_enemies
var enemies_node
var is_active = false
var tile_grid_lines = []

var active_tiles = []
var active_layer = 0
var inactive_layer = 1
var active_atlas_id = 0
var inactive_atlas_id = 1

var highlighted_x_idx
var highlighted_y_idx
var highlighted_line

var active_lines = []

func _ready():
	# get number of enemies
	enemies_node = self.get_parent().get_node("Enemies")
	for e in enemies_node.get_children():
		e.enemy_died.connect(_on_enemy_died)
	num_enemies = enemies_node.get_child_count()
	print(num_enemies)
	level_UI.set_tiles_remaining_label_text(selectable_tiles)
	level_UI.start_button_pressed.connect(start_level)
	draw_tile_grid()
	num_tiles_remaining = selectable_tiles

func _input(event):
	if(!is_active):
		if Input.is_action_just_pressed("left_click"):
			activate_tile()
			
func activate_tile():
	var global_mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = tile_map.local_to_map(global_mouse_pos)
	
	if(tile_mouse_pos in active_tiles):
		# Reset tile to initial layer (inactive tile)
		var tile_idx = active_tiles.find(tile_mouse_pos)
		active_tiles.pop_at(tile_idx)
		num_tiles_remaining += 1
		num_tiles_selected -= 1
		var atlas_coord = Vector2i(0, 0)
		tile_map.set_cell(1, tile_mouse_pos, 1, atlas_coord)
		level_UI.set_tiles_remaining_label_text(num_tiles_remaining)
	
	else:
		if(num_tiles_remaining > 0):
			# Set tile to active tiles
			var atlas_coord = tile_map.get_cell_atlas_coords(inactive_layer, tile_mouse_pos)
			tile_map.set_cell(1, tile_mouse_pos, 0, atlas_coord)
			num_tiles_selected += 1
			num_tiles_remaining -= 1
			level_UI.set_tiles_remaining_label_text(num_tiles_remaining)
			active_tiles.append(tile_mouse_pos)
		
	draw_active(active_tiles)

func draw_active(selected_idxs):
	for l in active_lines:
			l.queue_free()
			active_lines = []
			
	for item in selected_idxs:
		
		var rect = Line2D.new()
		rect.width = 5
		rect.default_color = Color(0, .6, .2, 1)
		
		var x_idx = item[0]
		var y_idx = item[1]
		rect.points = [
			Vector2(48 * x_idx, 48 * y_idx),
			Vector2(48 * (x_idx + 1), 48 * y_idx),
			Vector2(48 * (x_idx + 1), 48 * (y_idx + 1)),
			Vector2(48 * x_idx, 48 * (y_idx + 1)),
			Vector2(48 * x_idx, 48 * y_idx)
		]
		
		add_child(rect)
		active_lines.append(rect)

func _process(delta):
	if !is_active:
		var mouse_cord = get_global_mouse_position()
		var x_idx = floor(mouse_cord.x / 48)
		var y_idx = floor(mouse_cord.y / 48)
		
		if (x_idx != highlighted_x_idx or y_idx != highlighted_y_idx):
			highlighted_x_idx = x_idx
			highlighted_y_idx = y_idx
			
			if highlighted_line:
				highlighted_line.queue_free()
			
			var rect = Line2D.new()
			rect.width = 5
			rect.default_color = Color(0, .6, .2, 1)
			
			rect.points = [
				Vector2(48 * x_idx, 48 * y_idx),
				Vector2(48 * (x_idx + 1), 48 * y_idx),
				Vector2(48 * (x_idx + 1), 48 * (y_idx + 1)),
				Vector2(48 * x_idx, 48 * (y_idx + 1)),
				Vector2(48 * x_idx, 48 * y_idx)
			]
			
			add_child(rect)
			highlighted_line = rect

func start_level():
	level_UI.hide()
	is_active = true
	hide_tile_grid()
	highlighted_line.queue_free()

func draw_tile_grid():
	for i in range(0, 25):
		var my_line = Line2D.new()  # Instantiate a new Line2D object
		my_line.points = [Vector2(48 * i, 0), Vector2(48 * i, 700)]  # Set the points
		my_line.width = 1
		my_line.default_color = Color(.5, .5, .5, .75)  # Optional: Set the line color to red
		add_child(my_line)  # Attach the Line2D node to the current node
		tile_grid_lines.append(my_line)

	for i in range(0, 15):
		var my_line = Line2D.new()  # Instantiate a new Line2D object
		my_line.points = [Vector2(0, 48 * i), Vector2(1500, 48 * i)]  # Set the points
		my_line.width = 1
		my_line.default_color = Color(.5, .5, .5, .75)  # Optional: Set the line color to red
		add_child(my_line)  # Attach the Line2D node to the current node
		tile_grid_lines.append(my_line)

func hide_tile_grid():
	for item in tile_grid_lines:
		item.queue_free()

func get_is_active():
	return is_active

func _on_enemy_died():
	enemies_node = self.get_parent().get_node("Enemies")
	num_enemies = enemies_node.get_child_count()
	print(num_enemies)
	if num_enemies - 1 <= 0:
		GameManager.change_level(GameManager.current_level_index + 1)
