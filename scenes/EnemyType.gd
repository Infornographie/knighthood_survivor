extends Resource
class_name Enemy #set class name "Enemy"

#set Enemy properties
@export var title : String
@export var texture : SpriteFrames
@export var health : float
@export var damage : float
@export var drops : Array[Pickups]
