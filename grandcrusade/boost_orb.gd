extends Area2D

@export var boost_amount := 10

func _on_body_entered(body: Node2D) -> void:
	print("Collided with:", body.name)
	if body.is_in_group("player"):
		body.add_boost(boost_amount)
		queue_free()
