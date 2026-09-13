extends CanvasLayer

@onready var hurtbox := get_tree().get_first_node_in_group("hurt_player")
var paused := false
var wasted_time := 0.0

@onready var pause_menu := $PauseMenu
@onready var wasted_label := $PauseMenu/WastedLabel

func _process(delta):
	if hurtbox:
		$HealthBar.value = hurtbox.health
		print(hurtbox.health)
	else:
		$HealthBar.value = 0
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
	if paused:
		wasted_time += delta
		wasted_label.text = str(round(wasted_time)) + " seconds wasted"

func toggle_pause():
	paused = !paused
	get_tree().paused = paused
	pause_menu.visible = paused
	if not paused:
		wasted_time = 0.0
