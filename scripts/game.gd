extends Node2D

@export var enemy_seans: Array[PackedScene]=[]
@export var power_seans: Array[PackedScene]=[]
@onready var player_spown_pos = $PlayerSpownPos
@onready var laser_conteiner = $LaserConteiner
@onready var power_conteiner = $PowerConteiner
@onready var timer = $EnemySpownTimer
@onready var enemy_conteiner = $EnemyConteiner
@onready var hud = $UILayer/HUD
@onready var game_over_screan = $UILayer/GameOverScreen
@onready var parallax_background = $ParallaxBackground
@onready var laser_sound = $SFX/LaserSound
@onready var hit_sound = $SFX/HitSound
@onready var exploade_sound = $SFX/ExploadeSound
@onready var background_sound = $SFX/sound


var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score

var scroll_speed = 100

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()
	score = 0
	background_sound.play()
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_spown_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if timer.wait_time > 0.3:
		timer.wait_time -= delta * 0.007
	elif timer.wait_time < 0.3:
		timer.wait_time = 0.3
	parallax_background.scroll_offset.y += delta * scroll_speed
	if parallax_background.scroll_offset.y >= 960:
		parallax_background.scroll_offset.y = 0

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_conteiner.add_child(laser)
	laser_sound.play()


func _on_enemy_spown_timer_timeout():
	var e = enemy_seans.pick_random().instantiate()
	e.global_position = Vector2(randf_range(50,500),-50)
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	enemy_conteiner.add_child(e)

func _on_enemy_killed(points):
	hit_sound.play()
	score += points
	if score > high_score:
		high_score = score

func _on_enemy_hit():
	hit_sound.play()

func _on_player_killed():
	game_over_screan.set_score(score)
	game_over_screan.set_high_score(high_score)
	save_game()
	hud.visible = false
	await get_tree().create_timer(1.3).timeout
	game_over_screan.visible = true

func _on_power_spown_timer_timeout():
	var p = power_seans.pick_random().instantiate()
	p.global_position = Vector2(randf_range(50,500),-50)
	p.points_powerup_applied.connect(_on_points_powerup_applied)
	p.damage_powerup_applied.connect(_on_damage_powerup_applied)
	p.rate_of_fire_powerup_applied.connect(_on_rate_of_fire_powerup_applied)
	power_conteiner.add_child(p)

func _on_points_powerup_applied():
	score += 1000
	if score > high_score:
		high_score = score

func _on_rate_of_fire_powerup_applied():
	score += 700
	if score > high_score:
		high_score = score

func _on_damage_powerup_applied():
	score += 500
	if score > high_score:
		high_score = score
