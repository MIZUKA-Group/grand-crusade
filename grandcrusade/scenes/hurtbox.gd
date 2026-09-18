extends Area2D

@export var full_health := 25
var health := full_health

func _ready():
	add_to_group("hurt_player")

func take_damage(amount):
	health -= amount
	print("Red took", amount, "damage. Health:", health)
	if health <= 0:
		die()

func die():
	print("Red died")
	get_parent().queue_free()
	# game over logic later
