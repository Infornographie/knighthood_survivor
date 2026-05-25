extends CharacterBody2D

#variable to store player reference, direction and speed
@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 75
var damage : float
var elite : bool = false:
	set(value):
		elite = value
		if value:
			$AnimatedSprite2D.material = load("res://shaders/rainbow.tres")
			scale = Vector2(1.5,1.5)
			damage *= 2
			speed *= 1.2

var type : Enemy:
	set(value):
		type = value
		$AnimatedSprite2D.sprite_frames = value.texture
		damage = value.damage

func _physics_process(delta):
	var separation = (player_reference.position - position).length() #check separation from player
	if separation >= 1000 and not elite: #if separation is more than 500 free them from memory, except elite
		queue_free()
	
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

func _ready():
	add_to_group("Enemy")
