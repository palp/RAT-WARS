extends Node

@onready var config = ConfigFile.new()

func _ready():
	if FileAccess.file_exists("user_settings.ini"):
		config.load("user_settings.ini")
		load_volumes()

func load_volumes():
	for key in config.get_section_keys("volume"):
		var bus_index = AudioServer.get_bus_index(key)		
		if bus_index >= 0:
			var volume = config.get_value("volume", key)
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
			
func save_volumes(bus_names:Array):
	for bus_name in bus_names:
		var bus_index = AudioServer.get_bus_index(bus_name)		
		if bus_index >= 0:
			var volume = AudioServer.get_bus_volume_db(bus_index)
			config.set_value("volume", bus_name, db_to_linear(volume))
	save_config()

func save_config():
	config.save("user_settings.ini")
