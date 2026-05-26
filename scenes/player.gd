extends CharacterBody2D

var speed : float = 150
var health : float = 100:
	set(value):  #make health a setter variable to update progress bar
		health = value
		%Health.value = value

var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = INF

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation #if nearest_enemy is not null, store its separation
		print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF
	
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")


func take_damage(amount):
	health -= amount
	print(amount)


func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:  #disable & enable with each timeout
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
