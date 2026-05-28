extends PanelContainer

@export var item : PassiveItem:
	set(value):
		item = value
		$TextureRect.texture = value.texture.get_frame_texture("default", 0)

func _ready():
	if item!= null:
		item.player_reference = owner
