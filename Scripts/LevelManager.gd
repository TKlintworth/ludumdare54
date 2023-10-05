extends Node2D

@export var alive_enemies : int
@export var selectable_tiles : int
#@export var UI : Control
@export var tile_map : TileMap

var num_tiles_selected = 0
var num_tiles_remaining
var num_enemies
var enemies_node
var is_active = false
var tile_grid_lines = []
var active_tiles = []
var active_atlas_id = 0
var inactive_atlas_id = 1
var highlighted_x_idx
var highlighted_y_idx
var highlighted_line
var active_lines = []
var tile_size = 24
var start_button_focused = false
var MAX_Y
var MAX_X
var game_UI
var level_UI
var points_for_level = 100

func _ready():
	print("Level manager ready")
	MAX_Y = get_viewport().content_scale_size[1]
	MAX_X = get_viewport().content_scale_size[0]
	game_UI = get_node("/root/UI").Game_UI
	level_UI = get_node("/root/UI").Level_UI #GameManager.ui.Level_UI
	# get number of enemies
	enemies_node = self.get_parent().get_node("Enemies")
	for e in enemies_node.get_children():
		e.enemy_died.connect(_on_enemy_died)
	num_enemies = enemies_node.get_child_count()
	print(num_enemies)

	level_UI.set_tiles_remaining_label_text(selectable_tiles)
	level_UI.start_button_pressed.connect(start_level)
	level_UI.start_button_focus_enter.connect(start_button_focus_enter)
	level_UI.start_button_focus_exit.connect(start_button_focus_exit)
	draw_tile_grid()
	num_tiles_remaining = selectable_tiles
	
func start_button_focus_enter():
	print("focused")
	start_button_focused = true

func start_button_focus_exit():
	start_button_focused = false

func _input(event):
	if(!is_active):
		if Input.is_action_just_pressed("left_click"):
			# Check if youre clicking on the "start" button
			print("FOXUED OR NAH: ", start_button_focused)
			if(!start_button_focused):
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
		var atlas_coord = tile_map.get_cell_atlas_coords(0, tile_mouse_pos)
		var highest_layer = tile_map.get_layers_count()
		
		tile_map.set_cell(0, tile_mouse_pos, 1, atlas_coord)
		level_UI.set_tiles_remaining_label_text(num_tiles_remaining)
		#level_UI.set_multiplier_text(GameManager.score_multiplier)
	
	else:
		if(num_tiles_remaining > 0):
			# Set tile to active tiles
			# Set cell to collision atlas (id 1) at the same atlas_coord
			var atlas_coord = tile_map.get_cell_atlas_coords(0, tile_mouse_pos)
			# layer: int, coords: Vector2i, source_id: int = -1, atlas_coords:
			tile_map.set_cell(0, tile_mouse_pos, 0, atlas_coord)
			num_tiles_selected += 1
			num_tiles_remaining -= 1
			level_UI.set_tiles_remaining_label_text(num_tiles_remaining)
			#level_UI.set_multiplier_text(GameManager.score_multiplier)
			active_tiles.append(tile_mouse_pos)
			print(tile_mouse_pos)
	
	GameManager.update_score_multiplier(calculate_multiplier())
	draw_active(active_tiles)

func draw_active(selected_idxs):
	for l in active_lines:
			l.queue_free()
			active_lines = []
			
	for item in selected_idxs:
		
		var rect = Line2D.new()
		rect.width = 2
		rect.default_color = Color(0, .6, .2, 1)
		
		var x_idx = item[0]
		var y_idx = item[1]
		rect.points = [
			Vector2(tile_size * x_idx, tile_size * y_idx),
			Vector2(tile_size * (x_idx + 1), tile_size * y_idx),
			Vector2(tile_size * (x_idx + 1), tile_size * (y_idx + 1)),
			Vector2(tile_size * x_idx, tile_size * (y_idx + 1)),
			Vector2(tile_size * x_idx, tile_size * y_idx)
		]
		
		add_child(rect)
		active_lines.append(rect)

func _process(delta):
	if !is_active:
		var mouse_cord = get_global_mouse_position()
		var x_idx = floor(mouse_cord.x / tile_size)
		var y_idx = floor(mouse_cord.y / tile_size)
		
		if (x_idx != highlighted_x_idx or y_idx != highlighted_y_idx):
			highlighted_x_idx = x_idx
			highlighted_y_idx = y_idx
			
			if highlighted_line:
				highlighted_line.queue_free()
			
			var rect = Line2D.new()
			rect.width = 2
			rect.default_color = Color(0, .6, .2, 1)
			
			rect.points = [
				Vector2(tile_size * x_idx, tile_size * y_idx),
				Vector2(tile_size * (x_idx + 1), tile_size * y_idx),
				Vector2(tile_size * (x_idx + 1), tile_size * (y_idx + 1)),
				Vector2(tile_size * x_idx, tile_size * (y_idx + 1)),
				Vector2(tile_size * x_idx, tile_size * y_idx)
			]
			
			add_child(rect)
			highlighted_line = rect

func start_level():
	if(!level_UI.level_complete_mode):
		print("START LEVEL")
		level_UI.hide()
		#level_UI.level_start()
		is_active = true
		hide_tile_grid()
		highlighted_line.queue_free()
		draw_islands()
	else:
		print("level complete")
		#level_UI.level_complete_mode = false
		GameManager.change_level(GameManager.current_level_index + 1)

func draw_islands():
	for l in active_lines:
		l.queue_free()
		active_lines = []
	var islands = []
	var accounted_for = []
	var q = []
	
	for item in active_tiles:
		if item not in accounted_for:
			var island = [item]
			q.append(item)
			accounted_for.append(item)
			while len(q) > 0:
				var curr = q.pop_back()
				for item_1 in [
					Vector2i(curr[0], curr[1] + 1),
					Vector2i(curr[0], curr[1] - 1),
					Vector2i(curr[0] + 1, curr[1]),
					Vector2i(curr[0] - 1, curr[1])
				]:
					if item_1 in active_tiles and item_1 not in accounted_for:
						q.append(item_1)
						island.append(item_1)
						accounted_for.append(item_1)
						
			islands.append(island)

	for item in islands:
		draw_perim(item)

func draw_perim(selected_idxs):
	# Initialize min and max coordinates
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	# Find extremities
	for item in selected_idxs:
		var x_idx = item[0]
		var y_idx = item[1]
		if x_idx < min_x:
			min_x = x_idx
		if y_idx < min_y:
			min_y = y_idx
		if x_idx > max_x:
			max_x = x_idx
		if y_idx > max_y:
			max_y = y_idx

	# Create perimeter
	var rect = Line2D.new()
	rect.width = 2
	rect.default_color = Color(0, .6, .2, 1)
	rect.points = [
		Vector2(tile_size * min_x, tile_size * min_y),
		Vector2(tile_size * (max_x + 1), tile_size * min_y),
		Vector2(tile_size * (max_x + 1), tile_size * (max_y + 1)),
		Vector2(tile_size * min_x, tile_size * (max_y + 1)),
		Vector2(tile_size * min_x, tile_size * min_y)
	]
	
	add_child(rect)
	active_lines.append(rect)

func draw_tile_grid():
	
	for i in range(0, MAX_X / tile_size):
		var my_line = Line2D.new()  # Instantiate a new Line2D object
		my_line.points = [Vector2(tile_size * i, 0), Vector2(tile_size * i, 700)]  # Set the points
		my_line.width = 1
		my_line.default_color = Color(.5, .5, .5, .75)  # Optional: Set the line color to red
		add_child(my_line)  # Attach the Line2D node to the current node
		tile_grid_lines.append(my_line)

	for i in range(0, MAX_Y / tile_size):
		var my_line = Line2D.new()  # Instantiate a new Line2D object
		my_line.points = [Vector2(0, tile_size * i), Vector2(1500, tile_size * i)]  # Set the points
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
	$AudioStreamPlayer.play()
	enemies_node = self.get_parent().get_node("Enemies")
	num_enemies = enemies_node.get_child_count()
	GameManager.enemy_died()
	print(num_enemies)
	# If there are no enemies left, the level is over
	if num_enemies - 1 <= 0:
		GameManager.update_score(points_for_level, false)
		GameManager.level_complete()
		#GameManager.change_level(GameManager.current_level_index + 1)

func calculate_multiplier():
	print("selectabl_tiles:", selectable_tiles)
	print("num selected tiles:", num_tiles_selected)
	var multiplier = (1 - float(num_tiles_selected) / float(selectable_tiles)) * 4 + 1
	print("multiplier: ", multiplier)
	multiplier = "%.2f" % multiplier
	return multiplier
	
