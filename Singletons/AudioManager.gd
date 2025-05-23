# AudioManager.gd (需设置为AutoLoad单例)
extends Node

enum Bus { MASTER, MUSIC, SFX }
enum PitchMode { NORMAL, RANDOM }

# 音频总线配置
const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"

var music_value = 1
var SFX_value = 1

# 音频资源预加载字典（按需添加）
var _sound_map := { 
	"collide_1":preload("res://Assets/SFX/1.mp3"),
	"collide_2":preload("res://Assets/SFX/2.mp3"),
	"collide_3":preload("res://Assets/SFX/3.mp3"),
	"collide_4":preload("res://Assets/SFX/4.mp3"),
	"collide_5":preload("res://Assets/SFX/5.mp3"),
	"BGM":preload("res://Assets/Music/Arpent (mp3cut.net).mp3")
}

# 播放器配置
var _music_players: Array[AudioStreamPlayer] = []
var _sfx_players: Array[AudioStreamPlayer] = []
var _current_music_index: int = 0
var _music_fade_duration: float = 1.0

func _ready() -> void:
	_init_music_system()
	_init_sfx_system()

# 初始化音乐系统（双播放器交叉淡入淡出）
func _init_music_system() -> void:
	for i in 2:
		var player := AudioStreamPlayer.new()
		player.bus = MUSIC_BUS
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_child(player)
		_music_players.append(player)

# 初始化音效系统（6个固定播放器）
func _init_sfx_system() -> void:
	for i in 6:
		var player := AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		_sfx_players.append(player)

# 播放音乐（带淡入淡出）
func play_music(id: String) -> void:
	var stream: AudioStream = _sound_map.get(id)
	if not stream:
		push_error("未找到音乐资源: %s" % id)
		return
	
	var current_player = _music_players[_current_music_index]
	if current_player.stream == stream:
		return
	
	var target_index = 1 - _current_music_index
	var target_player = _music_players[target_index]
	
	# 新播放器淡入
	target_player.stream = stream
	_fade_in(target_player)
	
	# 旧播放器淡出
	_fade_out(current_player)
	
	_current_music_index = target_index

# 播放音效（带可选随机音高）
func play_sfx(id: String, pitch_mode: PitchMode = PitchMode.NORMAL) -> void:
	var stream: AudioStream = _sound_map.get(id)
	if not stream:
		push_error("未找到音效资源: %s" % id)
		return
	
	for player in _sfx_players:
		if not player.playing:
			player.stream = stream
			player.pitch_scale = randf_range(0.9, 1.1) if pitch_mode == PitchMode.RANDOM else 1.0
			player.play()
			break

# 音量控制（0-1线性范围）
func set_volume(bus: Bus, volume: float) -> void:
	var db := linear_to_db(clamp(volume, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus, db)

# 淡入逻辑
func _fade_in(player: AudioStreamPlayer) -> void:
	player.play()
	var tween := create_tween()
	tween.tween_property(player, "volume_db", 0.0, _music_fade_duration)

# 淡出逻辑
func _fade_out(player: AudioStreamPlayer) -> void:
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -40.0, _music_fade_duration)
	await tween.finished
	player.stop()
	player.stream = null
