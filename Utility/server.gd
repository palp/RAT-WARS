extends Node

signal create_session_request_complete
signal get_leaderboard_request_complete
signal update_session_request_complete
signal submit_session_request_complete

const API_URL = "https://ratwars-server.palp.workers.dev/api"

var leaderboard:Array
var session:Dictionary

@onready var get_leaderboard_http_request = HTTPRequest.new()
@onready var create_session_http_request = HTTPRequest.new()
@onready var update_session_http_request = HTTPRequest.new()
@onready var submit_session_http_request = HTTPRequest.new()

func _ready():	
	get_leaderboard_http_request.request_completed.connect(_on_leaderboard_response)
	add_child(get_leaderboard_http_request)
	create_session_http_request.request_completed.connect(_on_create_session_response)
	add_child(create_session_http_request)
	update_session_http_request.request_completed.connect(_on_update_session_response)
	add_child(update_session_http_request)
	submit_session_http_request.request_completed.connect(_on_submit_session_response)
	add_child(submit_session_http_request)

func create_game_session():
	if session != null:
		print_debug("Not replacing existing session!")
		return {}
	create_session_http_request.request(API_URL + '/sesson', PackedStringArray([]), HTTPClient.METHOD_POST)
	await create_session_request_complete
	return session

func update_game_session(score):
	if session.keys().size() == 0:
		print_debug("No session!")
		return {}
	update_session_http_request.request(API_URL + '/session/%s' % session.id, PackedStringArray([]), HTTPClient.METHOD_POST, JSON.stringify({"score": score}))
	await update_session_request_complete
	return session

func end_game_session():
	session = {}

func submit_game_session(name):
	if session.keys().size() == 0:
		print_debug("No session!")
		return {}
	submit_session_http_request.request(API_URL + '/session/%s/submit' % session.id, PackedStringArray([]), HTTPClient.METHOD_POST, JSON.stringify({"name": name}))
	await submit_session_request_complete
	session = {}
	return leaderboard

func get_leaderboard():		
	get_leaderboard_http_request.request(API_URL + '/leaderboard')
	await get_leaderboard_request_complete
	
	return leaderboard

func _on_create_session_response(result, response_code, headers, body):
	if response_code == 200:
		session = JSON.parse_string(body.get_string_from_utf8())
	emit_signal("create_session_request_complete")

func _on_leaderboard_response(result, response_code, headers, body):	
	if response_code == 200:
		leaderboard = JSON.parse_string(body.get_string_from_utf8())
	emit_signal("get_leaderboard_request_complete")
	
func _on_update_session_response(result, response_code, headers, body):
	if response_code == 200:
		session = JSON.parse_string(body.get_string_from_utf8())
	emit_signal("update_session_request_complete")

func _on_submit_session_response(result, response_code, headers, body):
	if response_code == 200:
		leaderboard = JSON.parse_string(body.get_string_from_utf8())
	emit_signal("submit_session_request_complete")
