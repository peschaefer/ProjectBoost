extends Node

# Array to hold the level scenes
var levels: Array = []
var current_level = 0

func _ready():
	load_levels("res://Scenes/Levels/")
	print(levels)

# Function to load level scenes dynamically
func load_levels(directory_path: String) -> void:
	levels.clear()
	var dir = DirAccess.open(directory_path)

	if dir != null:
		dir.list_dir_begin()  # Begin listing files
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir() == false:
				var level_path = directory_path + "/" + file_name
				if(level_path.split(".")[-1] == "remap"):
					level_path = level_path.replace(".remap", "")
				levels.append(level_path)
			file_name = dir.get_next()

		dir.list_dir_end()  # Clean up
	else:
		print("Failed to open directory:", directory_path)
	
	levels.sort_custom(custom_array_sort)

func load_level(level_index: int) -> void:
	if level_index < -1 or level_index > levels.size():
		print("Invalid level index:", level_index)
		return
	if level_index == levels.size():
		level_index = 0
		current_level = level_index
	if level_index == -1:
		level_index = levels.size() - 1
		current_level = level_index
	var level_scene = levels[level_index]
	if level_scene:
		get_tree().change_scene_to_file(level_scene)
	else:
		print("Failed to load level scene:", levels[level_index])
		
func next_level():
	current_level += 1
	load_level(current_level)

func previous_level():
	current_level -= 1
	load_level(current_level)
	
func custom_array_sort(a, b):
	var a_int: int = int(a.split("_")[1])
	var b_int: int = int(b.split("_")[1])
	return a_int < b_int
