extends Node2D

var version 
var build 
var api_base_url 

var logger = LogStream.new("config")

func _ready():
	var config = ConfigFile.new()
	var err = config.load("res://ratwars.cfg")
	if err != OK:
		logger.fatal("Unable to load ratwars.cfg!", err)
	
	version = config.get_value("release", "version")	
	build = config.get_value("release", "build")
	api_base_url = config.get_value("server", "api_base_url")
	logger.info("Config loaded ", { "version": version, "build": build })
