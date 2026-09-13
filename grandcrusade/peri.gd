extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

const SPEED = 100.0
const DETECTION_RANGE = 200.0

func _physics_process(_delta: float) -> void:
	var direction = 0.0

	# Check if player exists and is within range
	if player and global_position.distance_to(player.global_position) < DETECTION_RANGE:
		direction = sign(player.global_position.y - global_position.y)

	# Apply movement
	velocity.x = direction * SPEED


	move_and_slide()

	# Animations
	if direction != 0:
		animated_sprite_2d.animation = "move"
		animated_sprite_2d.flip_h = direction < 0
	else:
		animated_sprite_2d.animation = "idle"
