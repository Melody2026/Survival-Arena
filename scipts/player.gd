extends CharacterBody2D

@export var speed := 250.0

var health := 100
var invulnerable := false

var bullet_scene = preload("res://scenes/Bullet.tscn")

func _physics_process(_delta):
	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed
	move_and_slide()

	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("shoot"):
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()

	bullet.global_position = global_position
	bullet.direction = Vector2.RIGHT.rotated(rotation)

	get_tree().current_scene.add_child(bullet)

func _draw():
	var player_color = Color("#63d8ff")

	if invulnerable:
		player_color = Color("#ffffff")

	draw_circle(Vector2.ZERO, 16, player_color)
	draw_circle(Vector2.ZERO, 9, Color("#18232b"))
	draw_line(Vector2(8, 0), Vector2(24, 0), Color("#ffffff"), 5)
	
	  
func take_damage(amount):
	if invulnerable:
		return

	health -= amount
	invulnerable = true
	queue_redraw()

	print("PLAYER HIT! HP:", health)

	await get_tree().create_timer(0.5).timeout

	invulnerable = false
	queue_redraw()

	if health <= 0:
		health = 0
		get_tree().current_scene.game_over_screen()
