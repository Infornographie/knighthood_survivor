extends Resource
class_name Pickups

@export var title : String
@export var icon : SpriteFrames
@export_multiline var description : String

var player_reference : CharacterBody2D


func activate():
	print(title + " picked up.")
