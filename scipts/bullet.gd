extends Area2D

@export var speed := 600.0
@export var damage := 1

var direction := Vector2.RIGHT

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	print("BULLET HIT: ", body.name)

	if body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color("#fff2a8"))
