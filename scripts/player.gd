class_name Player extends CharacterBody2D

signal laser_shot(laser_scene, location)
signal killed

@export var damage = 1
@export var speed = 300
@export var rate_of_fire = 0.25
@onready var exploade_sound = $ExploadeSound
@onready var muzzle = $Muzzle
@onready var muzzle2 = $Muzzle2
@onready var animation = $Sprite2D/AnimatedSprite2D

var texture_left: Texture
var texture_right: Texture
var texture_main: Texture

var current_texture: Texture

var leser_scene = preload("res://scenes/laser.tscn")

var shoot_cd := false

func _ready():

	texture_left = preload("res://assets/Player ship/Player_ship (left).png")
	texture_right = preload("res://assets/Player ship/Player_ship (right).png")
	texture_main = preload("res://assets/Player ship/Player_ship (up).png")

	current_texture = texture_main
	update_texture()

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot()
			await get_tree().create_timer(rate_of_fire).timeout
			shoot_cd = false

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))

	if direction.x < 0:
		current_texture = texture_left
	elif direction.x > 0:
		current_texture = texture_right
	else:
		current_texture = texture_main
	update_texture()
	velocity = direction * speed
	move_and_slide()

	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func update_texture():
	if current_texture:
		$Sprite2D.texture = current_texture

func shoot():
	laser_shot.emit(leser_scene, muzzle.global_position)
	laser_shot.emit(leser_scene, muzzle2.global_position)


func die():
	animation.play("default")
	exploade_sound.play()

func _on_animated_sprite_2d_animation_finished():
	killed.emit()
	queue_free()
