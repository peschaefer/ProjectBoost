extends CSGBox3D

@onready var collect_audio: AudioStreamPlayer = $CollectAudio
@onready var coin_display: RichTextLabel = $UI/CoinDisplay
@onready var time_display: RichTextLabel = $UI/TimeDisplay
@onready var highscore_display: RichTextLabel = $UI/HighscoreDisplay
@onready var player: RigidBody3D = $Player
@onready var highscore_handler = preload("res://Scenes//Scripts//high_score_handler.gd").new()
var landing_pad
var current_level

var coins_collected = 0
var coins_total
var coin_map: Dictionary

var time_in_milliseconds = 0
var timer_running: bool = false

func _ready() -> void:
	var coins = get_tree().get_nodes_in_group("Coin")
	coins_total = coins.size()
	populate_coin_map(coins)
	update_coin_count()
	reset_player()
	update_highscore_display()
	current_level = get_parent().level
	landing_pad = get_tree().get_first_node_in_group("Goal")
	for coin in coins:
		coin.connect("collected", _on_collect_coin)
	player.connect("crashed", _on_crash)
	player.connect("level_completed", _on_level_completed)
	player.connect("liftoff", _on_lift_off)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(timer_running):
		time_in_milliseconds += delta * 1000
		update_time_display()
	if Input.is_action_just_pressed("next-level"):
		LevelHandler.next_level()
	if Input.is_action_just_pressed("previous-level"):
		LevelHandler.previous_level()

func _on_collect_coin(coin_id: int):
	coins_collected+=1
	update_coin_count()
	collect_audio.play()
	var coin_in_question = coin_map[coin_id]
	coin_in_question.disabled = true
	coin_in_question.hide()

func update_coin_count():
	coin_display.text = "%d/%d Coins" % [coins_collected, coins_total]

func populate_coin_map(coins: Array):
	coin_map = {}
	for coin in coins:
		coin_map[coin.get_instance_id()] = coin
		
func reset_coins():
	for coin in coin_map.values():
		coin.disabled = false
		coin.show()
	coins_collected = 0
	update_coin_count()

func update_time_display():
	time_display.text = stringify_time(time_in_milliseconds)

func stringify_time(time: float) -> String:
	var milliseconds = floori(time) % 1000
	var seconds = floori(time/1000) % 60
	var minutes = floori((time/1000)/60)
	return "%s:%s:%s" % [str(minutes).pad_zeros(2), str(seconds).pad_zeros(2), str(milliseconds).pad_zeros(3)]
	
func reset_player():
	var launch_pad = get_tree().get_first_node_in_group("LaunchPad")
	if !launch_pad:
		return
	disable_player()
	var spawn_point = launch_pad.get_node_or_null("SpawnPoint")
	if spawn_point:
		player.global_transform.origin = spawn_point.global_transform.origin
		player.transform.basis = spawn_point.global_transform.basis
	enable_player()
	reset_coins()

func disable_player():
	player.disabled = true
	
func enable_player():
	player.disabled = false

func _on_crash():
	disable_player()
	stop_timer()
	var tween: Tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(
		reset_player
	)
	
func _on_level_completed():
	disable_player()
	update_highscores()
	stop_timer()
	var tween: Tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(
	transition_level
	)

func transition_level():
	LevelHandler.next_level()

func update_highscores():
	var highscores = highscore_handler.read_json_file()
	if highscores.has(current_level):
		highscores[current_level] = time_in_milliseconds if time_in_milliseconds < highscores[current_level] else highscores[current_level]
	else:
		highscores[current_level] = time_in_milliseconds
	highscore_handler.update_json_file(highscores)
	update_highscore_display()
	
func update_highscore_display():
	current_level = get_parent().level
	var highscores = highscore_handler.read_json_file()
	if highscores.has(current_level):
		highscore_display.text = "🏆 " + stringify_time(highscores[current_level])
	else:
		highscore_display.text = "🏆 --:--:---"

func _on_lift_off():
	timer_running = true

func stop_timer():
	timer_running = false
	time_in_milliseconds = 0
