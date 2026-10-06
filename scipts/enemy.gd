extends CharacterBody2D

@export var speed := 80.0
@export var health := 3

var damage_cooldown := 0.0

var player: CharacterBody2D

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	damage_cooldown = max(0.0, damage_cooldown - delta)

	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

		if global_position.distance_to(player.global_position) < 30:
			if damage_cooldown <= 0.0:
				player.take_damage(10)
				damage_cooldown = 0.8
				

func take_damage(amount):
	health -= amount

	if health <= 0:
		var main = get_tree().current_scene
		main.add_score(10)
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 18, Color("#ff5c7a"))
	draw_circle(Vector2.ZERO, 10, Color("#40151f"))
	draw_circle(Vector2(-5, -3), 3, Color.WHITE)
	draw_circle(Vector2(5, -3), 3, Color("#ffffff"))
