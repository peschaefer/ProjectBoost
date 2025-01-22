extends Node

var filepath = "user://highscores.json"

# Create or overwrite the JSON file with initial data
func create_highscore_file(data: Dictionary) -> void:
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(data, "\t")  # "\t" adds pretty formatting
		file.store_string(json_string)
		file.close()
	else:
		print("Failed to create JSON file.")

# Read and parse the JSON file
func read_json_file() -> Dictionary:
	var file = FileAccess.open(filepath, FileAccess.READ_WRITE)
	var json = JSON.new()
	if file:
		var content = file.get_as_text()
		file.close()
		if !content: 
			return {}
		var parsed = json.parse(content)
		if parsed == OK:
			return json.get_data() # Returns the parsed dictionary
	return {}  # Return an empty dictionary on failure

# Update the JSON file with new data
func update_json_file(new_data: Dictionary) -> void:
	var existing_data = read_json_file()
	for key in new_data.keys():
		existing_data[key] = new_data[key]  # Update or add new keys
	create_highscore_file(existing_data)  # Rewrite the file with updated data
