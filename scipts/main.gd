extends Node2D

var enemy_scene = preload("res://scenes/Enemy.tscn")

@onready var spawn_timer = $EnemySpawnTimer

var wave := 1

var score := 0

@onready var player = $Player
@onready var wave_label = $HUD/WaveLabel
@onready var score_label = $HUD/ScoreLabel
@onready var health_label = $HUD/HealthLabel

@onready var game_over_panel = $HUD/GameOver
@onready var final_score = $HUD/GameOver/FinalScore

var enemies_to_spawn := 5
var enemies_spawned := 0

var game_over := false

func _ready():
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()

func spawn_enemy():
	if enemies_spawned >= enemies_to_spawn:
		spawn_timer.stop()
		return

	var enemy = enemy_scene.instantiate()

	var side = randi() % 4

	match side:
		0:
			enemy.position = Vector2(randf_range(0, 960), -30)
		1:
			enemy.position = Vector2(990, randf_range(0, 540))
		2:
			enemy.position = Vector2(randf_range(0, 960), 570)
		3:
			enemy.position = Vector2(-30, randf_range(0, 540))

	add_child(enemy)
	enemies_spawned += 1


func _process(_delta):
	var enemies_alive = get_tree().get_nodes_in_group("enemy").size()

	if enemies_spawned >= enemies_to_spawn and enemies_alive == 0:
		start_next_wave()
	
	wave_label.text = "WAVE " + str(wave)
	score_label.text = "SCORE: " + str(score)
	health_label.text = "HP: " + str(player.health)


func start_next_wave():
	wave += 1
	enemies_to_spawn += 3
	enemies_spawned = 0

	print("WAVE ", wave)

	spawn_timer.start()
	
func add_score(points):
	score += points

func game_over_screen():
	game_over = true
	spawn_timer.stop()

	# Remove all remaining enemies
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()

	game_over_panel.visible = true
	final_score.text = "Score: " + str(score)


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
