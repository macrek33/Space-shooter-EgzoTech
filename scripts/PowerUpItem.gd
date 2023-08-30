extends Area2D

signal damage_powerup_applied
signal rate_of_fire_powerup_applied
signal points_powerup_applied

enum PowerUpType {
	DAMAGE,
	RATE_OF_FIRE,
	POINTS
}

var randomValue = randi_range(0, 2)
@export var speed = 180
var powerUpType: PowerUpType
var textureDict := {
	PowerUpType.DAMAGE: preload("res://assets/Items/Power_B (16 x 16).png"),
	PowerUpType.RATE_OF_FIRE: preload("res://assets/Items/Power_C (16 x 16).png"),
	PowerUpType.POINTS: preload("res://assets/Items/Power_A (16 x 16).png")
}

func _ready():
	var sprite = $Sprite2D
	sprite.texture = textureDict[randomValue]

func _physics_process(delta):
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		applyPowerUp()

func applyPowerUp():
	match randomValue:
		PowerUpType.DAMAGE:
			emit_signal("damage_powerup_applied")
			print("DAMAGE")
		PowerUpType.RATE_OF_FIRE:
			emit_signal("rate_of_fire_powerup_applied")
			print("RATE_OF_FIRE")
		PowerUpType.POINTS:
			emit_signal("points_powerup_applied")
			print("POINTS")
	queue_free()
