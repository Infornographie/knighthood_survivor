extends Area2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1

var time : float = 0.0

func _physics_process(delta):
	#position += direction * speed * delta
	#rotation += 5.0 * delta
	time += delta
	var wobble = direction.rotated(PI/2) * (sin(time * 7.0) * 50.0 + sin(time * 13.0) * 25.0)
	position += (direction * speed + wobble) * delta
	rotation += 5.0 * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		body.knockback += direction * 75


func _on_screen_exited() -> void:
	var particles = $GPUParticles2D
	remove_child(particles)
	get_tree().current_scene.add_child(particles)
	particles.emitting = false
	await get_tree().create_timer(2.0).timeout
	particles.queue_free()
	queue_free()
