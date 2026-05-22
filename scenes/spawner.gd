extends Node2D

#One variable for holding player reference & another for holding enemy node
@export var player : CharacterBody2D
@export var enemy : PackedScene

var distance : float = 800 #distance from which the enemy will be spawning

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


func spawn(pos : Vector2): #instanciate the enemy node & set spawn position & player reference
	var enemy_instance = enemy.instantiate() 
	
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	
	get_tree().current_scene.add_child(enemy_instance) #add it to the scene tree


func get_random_position() -> Vector2:
	return player.position + distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI)) #function to get random position from player at a particular distance
	


func amount(number : int = 1):
	for i in range(number):
		spawn(get_random_position()) #function to spawn multiple enemy at a time

func _on_timer_timeout() -> void:
	second += 1
	amount(second % 10) #increment "second" with each timeout and spawn enemies
