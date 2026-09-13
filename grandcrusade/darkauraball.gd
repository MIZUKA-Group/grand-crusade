extends Area2D

var speed = 500.0
var direction = Vector2.RIGHT
var shooter

func _ready():
	add_to_group("attack_enemy")
	connect("area_entered", Callable(self, "_on_area_entered"))

func _physics_process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	if area.is_in_group("hurt_player"):
		area.take_damage(1)
		queue_free()

	if area.get_parent() == shooter:
		return  # ignore Red
