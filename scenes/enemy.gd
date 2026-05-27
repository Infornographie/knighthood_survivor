extends CharacterBody2D

#variable to store player reference, direction and speed
@export var player_reference : CharacterBody2D
var damage_popup_node = preload("res://scenes/damage.tscn")
var direction : Vector2
var speed : float = 75
var damage : float
var knockback : Vector2
var separation : float

var drop = preload("res://scenes/pickups.tscn")

var is_dead : bool
var health : float:
	set(value):
		health = value
		if health <= 0 and not is_dead:
			is_dead = true
			$AnimatedSprite2D.play("death")
			await get_tree().create_timer(1.0).timeout
			var tween = get_tree().create_tween()
			tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.05)
			tween.chain().tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.05)
			tween.chain().tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.05)
			tween.chain().tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.05)
			tween.chain().tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.1)
			await tween.finished
			drop_item()
			queue_free()

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
		health = value.health

func _physics_process(delta):
	if is_dead:
		return
	check_separation(delta)
	knockback_update(delta)
	
		#Turn the sprite facing
	if direction.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite2D.flip_h = true
		
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

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

func damage_popup(amount): #instantiate damage popup & add it to scene tree
	var popup = damage_popup_node.instantiate()
	popup.text = str(int(amount))
	popup.position = position + Vector2(-50,-25)
	get_tree().current_scene.add_child(popup)

func take_damage(amount):
	var tween = get_tree().create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(3, 0.25, 0.25), 0.2)
	tween.chain().tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1), 0.2)
	tween.bind_node(self)
	damage_popup(amount)
	health -= amount

func drop_item():
	if type.drops.size() == 0:
		return
	
	var item = type.drops.pick_random()
	
	var item_to_drop = drop.instantiate()
	
	item_to_drop.type = item
	item_to_drop.position = position
	item_to_drop.player_reference = player_reference
	
	get_tree().current_scene.call_deferred("add_child", item_to_drop)

func _ready():
	add_to_group("Enemy")
