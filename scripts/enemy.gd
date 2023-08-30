class_name Enemy extends Area2D

enum EnemyType {
	TYPE_A,
	TYPE_B,
	TYPE_C,
}

signal killed(points)
signal hit

@export var speed: int = 150
@export var hp: int = 1
@export var points: int = 100
@export var enemy_type: EnemyType = EnemyType.TYPE_A
@onready var animation = $Sprite2D/AnimatedSprite2D

func _ready():
	set_animation()

func _physics_process(delta):
	global_position.y += speed * delta

func die():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()

func set_animation():
	match enemy_type:
		EnemyType.TYPE_A:
			animation.play("alien")
		EnemyType.TYPE_B:
			animation.play("lips")
		EnemyType.TYPE_C:
			animation.play("bon")
		# Dodaj obsługę innych typów przeciwników tutaj
