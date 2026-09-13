extends Area2D

@export var full_health := 3
var health := full_health

func _ready():
	add_to_group("hurt_enemy")

func take_damage(amount):
	health -= amount
	print("Enemy took", amount, "damage. Health:", health)
	if health <= 0:
		die()

func die():
	print("Enemy died")
#	call_deferred("drop_orb")
	get_parent().queue_free()

#func drop_orb():
#	var orb = preload("res://BoostOrb.tscn").instantiate()
#	orb.global_position = get_parent().global_position
#	get_tree().current_scene.add_child(orb)
