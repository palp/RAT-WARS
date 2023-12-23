extends Node

var audio_player:AudioStreamPlayer = AudioStreamPlayer.new()

var tracks = [
{
	"name": "UNLOVED",
	"resource": "res://Audio/Music/UNLOVED LOOP.mp3"
},
]

var boss_tracks = [
{
	"name": "DSM-V",
	"resource": "res://Audio/Music/DSM-V LOOP.mp3"
}	
]

var current_track_index = 0
var current_track:AudioStream
var next_track:AudioStream
var boss_music_playing = false

func _ready():
	add_child(audio_player)
	audio_player.volume_db = -10
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	audio_player.finished.connect(_on_audio_player_finished)
	audio_player.bus = "Music"
	select_track(current_track_index)

func _on_audio_player_finished():
	audio_player.play()
	
func _on_boss_fight_start(index=0):
	if not boss_music_playing:
		boss_music_playing = true
		if index >= len(tracks):
			index = 0
		audio_player.stream = load(boss_tracks[index]["resource"])
		audio_player.play()

func _on_boss_fight_end():
	if boss_music_playing:
		boss_music_playing = false
		play_current_track()
		audio_player.stream_paused = true
	
func select_track(index):	
	if index < len(tracks):
		print_debug("selecting track " + tracks[index]["name"])
		current_track_index = index
		play_current_track()

func play_current_track():
	if not boss_music_playing:
		audio_player.stream = load(tracks[current_track_index]["resource"])
		if not audio_player.stream_paused:
			audio_player.play()
