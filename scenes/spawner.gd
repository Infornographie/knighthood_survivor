extends Node2D

#One variable for holding player reference & another for holding enemy node
@export var player : CharacterBody2D
@export var enemy : PackedScene
@export var destructible : PackedScene

var distance : float = 800 #distance from which the enemy will be spawning
var can_spawn : bool = true

@export var enemy_types : Array[Enemy] #Variable to store array of enemy

var minute : int: #minute setter variable will be updating the "Minute" label
	set(value):
		minute = value
		%Minute.text = str(value) 
		
var second : int:
	set(value):
		second = value
		if second >= 60: #second setter variable will be updating minute
			second -= 60
			minute += 1
		%Second.text = str(second).lpad(2,'0') #also set a padding to the left


func _physics_process(_delta):
	#print(get_tree().get_node_count_in_group("Enemy"))
	if get_tree().get_node_count_in_group("Enemy") < 400: #spawner will only spawn mobs if count is under 400
		can_spawn = true
	else:
		can_spawn = false


func spawn(pos : Vector2, elite : bool = false): #instanciate the enemy node & set spawn position & player reference
	if not can_spawn and not elite: #using flag to control spawn
		return
	
	var enemy_instance = enemy.instantiate() 
	
	enemy_instance.type = enemy_types[min(minute, enemy_types.size()-1)] #each minute will be a different wave of enemy
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	enemy_instance.elite = elite
	
	get_tree().current_scene.add_child(enemy_instance) #add it to the scene tree


func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI)) #function to get random position from player at a particular distance
	


func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position()) #function to spawn multiple enemy at a time

func _on_timer_timeout() -> void:
	second += 1
	amount(second % 10) #increment "second" with each timeout and spawn enemies


func _on_pattern_timeout() -> void:
	for i in range(75):
		spawn(get_random_position())  #if the sample size is enough, randomness will create a circle


func _on_elite_timeout() -> void:
	print("elite spawn!")
	spawn(get_random_position(), true)


func _on_destructible_timeout() -> void:
	spawn_destructible(get_random_position())

func spawn_destructible(pos):
	var object_instance = destructible.instantiate()
	object_instance.position = pos
	get_tree().current_scene.add_child(object_instance)
