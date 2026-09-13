extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@export var attack_range := 80
@export var attack_cooldown := 2.5
@onready var attack_point: Marker2D = $AttackPoint
@onready var blast: AudioStreamPlayer2D = $blast


var can_attack := true

@export var dark_aura_scene: PackedScene



const SPEED = 100.0
const DETECTION_RANGE = 150.0

func _physics_process(delta: float) -> void:
	if not player:
		return
		
	var distance = global_position.distance_to(player.global_position)
		
	if distance > attack_range:
		chase_player(delta)
	else:
		attack_player()

func chase_player(delta):
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
	 # Animations
	if direction != 0:
		animated_sprite_2d.animation = "move"
		animated_sprite_2d.flip_h = direction < 0
	else:
		animated_sprite_2d.animation = "idle"

func attack_player():
	velocity = Vector2.ZERO  # stop moving while attacking
	if not can_attack:
		return
	
	can_attack = false
	
	var ball = dark_aura_scene.instantiate()
	
	var facing_left = animated_sprite_2d.flip_h
	var player_left = player.global_position.x < global_position.x
	
	# If enemy is facing the wrong way, turn instead of attacking
	if facing_left != player_left:
		# turn to face player instead of attacking backwards
		animated_sprite_2d.flip_h = player_left
		return
	
	ball.global_position = attack_point.global_position
	ball.shooter = self
	ball.direction = (player.global_position - global_position).normalized()
	
	blast.play()
	get_tree().current_scene.add_child(ball)
	
	animated_sprite_2d.animation = "idle"  # later: add attack animation
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
