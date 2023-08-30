extends Area2D

@export var speed = 600
@export var damage = 1

func _ready():
	
	var player = get_node("/root/Player")  # Ścieżka do węzła gracza
	if player:
		damage = player.damage
	#var damage_powerup = damage_powerup_applied.connect(on_damage_powerup_applied)

func _physics_process(delta):
	global_position.y -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Enemy:
		area.take_damage(damage)
		queue_free()

func on_damage_powerup_applied():
	damage += 0.1
