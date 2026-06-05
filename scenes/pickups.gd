extends Area2D

var direction : Vector2
var speed : float = 250

@export var type : Pickups
@export var player_reference : CharacterBody2D:
	set(value):
		player_reference = value
		type.player_reference = value

var can_follow : bool = false

func _ready():
	$AnimatedSprite2D.sprite_frames = type.icon

func _physics_process(delta):
	if player_reference and can_follow:
		direction = (player_reference.position - position).normalized()
		var dynamic_speed = max(speed, player_reference.movement_speed * 1.2)
		print("speed: ", speed, " player: ", player_reference.movement_speed, " dynamic: ", dynamic_speed)
		position += direction * dynamic_speed * delta

func follow(_target : CharacterBody2D, gem_flag = false):
	if type is Chest:
		return
	if gem_flag == true:
		if type is Gem:
			can_follow = true
		return
	can_follow = true


func _on_body_entered(body: Node2D) -> void:
	type.activate()
	queue_free()
