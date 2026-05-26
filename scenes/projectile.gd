extends Area2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1

func _physics_process(delta):
	position += direction * speed * delta


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
