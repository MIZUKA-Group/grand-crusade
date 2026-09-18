extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump: AudioStreamPlayer2D = $Jump
@onready var step: AudioStreamPlayer2D = $Step
@export var bullet_scene: PackedScene
@onready var attack_point = $AttackPoint
@onready var shot: AudioStreamPlayer2D = $Shoot
@export var max_boost := 100
var boost := 0

func add_boost(amount):
	boost = clamp(boost + amount, 0, max_boost)
	print("Boost:", boost)

func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.shooter = self
	
	# Base position from the Marker2D
	bullet.global_position = attack_point.global_position
	
	# Flip bullet direction and spawn side
	if animated_sprite_2d.flip_h:
		bullet.direction = Vector2.LEFT
		# Mirror the spawn point horizontally
		bullet.global_position.x = global_position.x - abs(attack_point.position.x)
	else:
			bullet.direction = Vector2.RIGHT
			bullet.global_position.x = global_position.x + abs(attack_point.position.x)

const SPEED = 400.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Animations
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "move"
	else:
		animated_sprite_2d.animation = "idle"

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		jump.play()
		animated_sprite_2d.animation = "salta"

	# up
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("attack"):
		shot.play()
		animated_sprite_2d.animation = "salta"
		shoot()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	# left and right
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
