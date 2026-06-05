extends Area2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 200
var damage : float = 1
var source
var time : float = 0.0
var exiting : bool = false


func _physics_process(delta):
	#position += direction * speed * delta
	#rotation += 5.0 * delta
	time += delta
	var wobble = direction.rotated(PI/2) * (sin(time * 7.0) * 50.0 + sin(time * 13.0) * 25.0)
	position += (direction * speed + wobble) * delta
	rotation += 5.0 * delta


func _on_body_entered(body):
	if body.has_method("take_damage"):
		if "might" in source:
			body.take_damage(damage * source.might)
		else:
			body.take_damage(damage)
		
		body.knockback += direction * 75


func _on_screen_exited():
	if exiting:
		return
	exiting = true
	var particlesBack = $GPUParticles2D
	var particlesFront = $GPUParticles2D2
	var global_pos = global_position
	
	remove_child(particlesBack)
	remove_child(particlesFront)
	get_tree().current_scene.add_child(particlesFront)
	get_tree().current_scene.add_child(particlesBack)
	
	particlesFront.global_position = global_pos
	particlesBack.global_position = global_pos
	
	particlesFront.emitting = false
	particlesBack.emitting = false
	
	await get_tree().create_timer(2.0).timeout
	particlesFront.queue_free()
	particlesBack.queue_free()
	queue_free()


func _on_area_entered(area):
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(damage)
