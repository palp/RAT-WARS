extends Node2D

var api_base_url 

var logger = LogStream.new("config")

func _ready():
	load_config()

func set_values(config):
	api_base_url = config.get_value("server", "api_base_url")

func load_config():
	var config = ConfigFile.new()	
	if FileAccess.file_exists("res://ratwars.cfg.prod") and FileAccess.file_exists("res://config.key"):
		var key = CryptoKey.new()
		var key_err = key.load("res://config.key")
		if key_err != OK:
			logger.warn("Unable to load config.key!", key_err)
		else:
			var config_err = config.load_encrypted_pass("res://ratwars.cfg.prod", key.save_to_string())
			if config_err != OK:
				logger.warn("Unable to load ratwars.cfg.prod!", config_err)
			else:
				logger.info("Loaded encrypted config")
				set_values(config)
				return

	var err = config.load("res://ratwars.cfg")
	if err != OK:
		logger.fatal("Unable to load ratwars.cfg!", err)

	if FileAccess.file_exists("res://config.key"):		
		var key = CryptoKey.new()
		var key_err = key.load("res://config.key")
		if key_err != OK:
			logger.warn("Unable to load config.key!", key_err)
		config.save_encrypted_pass("res://ratwars.cfg.prod", key.save_to_string())
		logger.info("Wrote encrypted config")
	logger.info("Loaded config")
	set_values(config)
