extends Node

var audio_player:AudioStreamPlayer = AudioStreamPlayer.new()

var tracks = [
{
	"name": "DEMIGODS",
	"resource": "DEMIGODS LOOP.mp3"	
},
{
	"name": "FUTURE OF HELL",
	"resource": "FUTURE OF HELL LOOP.mp3"
},
{
	"name": "(OF ALL ELSE)",
	"resource": "(OF ALL ELSE) LOOP.mp3"
},
{
	"name": "CRACK METAL",
	"resource": "CRACK METAL LOOP.mp3"
},
{
	"name": "UNLOVED",
	"resource": "UNLOVED LOOP.mp3"
},
{
	"name": "CHILDREN OF SORROW",
	"resource": "CHILDREN OF SORROW LOOP.mp3"
},
{
	"name": "SICKO",
	"resource": "SICKO LOOP.mp3"
},
{
	"name": "ASHAMED",
	"resource": "ASHAMED LOOP.mp3"
},
{
	"name": "DON'T TRY",
	"resource": "DONT TRY LOOP.mp3"
}
]

var boss_tracks = [
{
	"name": "DSM-V",
	"resource": "DSM-V LOOP.mp3"
}	
]

var current_track_index = 0
var current_track:AudioStream
var next_track:AudioStream
var boss_music_playing = false

func _ready():
	add_child(audio_player)
	current_track_index = randi_range(0, len(tracks))
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
		audio_player.stream = load("res://Audio/Music/" + boss_tracks[index]["resource"])
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
		audio_player.stream = load("res://Audio/Music/" + tracks[current_track_index]["resource"])
		if not audio_player.stream_paused:
			audio_player.play()
