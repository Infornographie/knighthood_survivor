extends CharacterBody2D

var speed : float = 150

func _physics_process(delta):
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
