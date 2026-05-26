extends CharacterBody2D

#variable to store player reference, direction and speed
@export var player_reference : CharacterBody2D
var direction : Vector2
var speed : float = 75
var damage : float
var knockback : Vector2
var separation : float
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
	check_separation(delta)
	knockback_update(delta)

func check_separation(_delta):
	separation = (player_reference.position - position).length()
	if separation >= 1000 and not elite:
		queue_free()
	
	# if any enemy is nearer, it will update the nearest_enemy from enemy to player
	if separation < player_reference.nearest_enemy_distance:
		player_reference.nearest_enemy = self

func knockback_update(delta):
	direction = (player_reference.position - position).normalized()
	velocity = direction * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1) #knockback will be decaying over time
	velocity += knockback #adding knockback to velocity
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 70 #applies knockback to bodies colliding with the enemy

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
