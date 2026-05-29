extends CharacterBody2D

var health : float = 100:
	set(value):  #make health a setter variable to update progress bar
		health = max(value, 0)
		%Health.value = value
var movement_speed : float = 150
var max_health : float = 100:
	set(value):
		max_health = value
		%Health.max_value = value
var recovery : float = 0
var armor : float = 0
var might : float = 1
var area : float = 0
var magnet : float = 0:
	set(value):
		magnet = value
		%Magnet.shape.radius = 80 + value
var growth : float = 1
var nearest_enemy
var nearest_enemy_distance : float = 400 + area
var gold : int = 0:
	set(value):
		gold = value
		%Gold.text = "Gold: " + str(value)

var XP: int = 0:
	set(value):
		XP = value
		%XP.value = value
		print("XP: ", value)
var total_XP : int = 0
var level : int = 1:
	set(value):
		level = value
		%Level.text = "Lv. " + str(value)
		%Options.show_option()
		
		if level >= 3:
			%XP.max_value = 20
		elif level >= 7:
			%XP.max_value = 40


func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation #if nearest_enemy is not null, store its separation
		#qqqqqprint(nearest_enemy.name)
	else:
		nearest_enemy_distance = 400 + area
		nearest_enemy = null
	
	velocity = Input.get_vector("left","right","up","down") * movement_speed
	move_and_collide(velocity * delta)
	check_XP()
	health += recovery * delta
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")


func take_damage(amount):
	health -= max(amount - armor, 0)
	#print(amount)


func _on_self_damage_body_entered(body: Node2D) -> void:
	take_damage(body.damage)


func _on_timer_timeout() -> void:  #disable & enable with each timeout
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)

func gain_XP(amount):
	XP += amount * growth
	total_XP += amount * growth

func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1


func _on_magnet_area_entered(area):
	if area.has_method("follow"): #call the follow function from the pickups
		area.follow(self)

func gain_gold(amount):
	gold += amount

func open_chest():
	$UI/Chest.open()
