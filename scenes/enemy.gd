extends CharacterBody2D

#variable to store player reference, direction and speed
@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 75
var damage : float

var type : Enemy:
	set(value):
		type = value
		$AnimatedSprite2D.sprite_frames = value.texture
		damage = value.damage

func _physics_process(delta):
	direction = (player_reference.position - position).normalized()
	velocity = direction * speed
	move_and_collide(velocity * delta)
	#Enemy will be moving towards player position
	
	#Turn the sprite facing
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")
