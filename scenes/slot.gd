extends PanelContainer

@export var weapon : Weapon:
	set(value):
		weapon = value
		$TextureRect.texture = value.texture.get_frame_texture("default", 0)
		$Cooldown.wait_time = value.cooldown


func _on_cooldown_timeout() -> void:
	if weapon:
		$Cooldown.wait_time = weapon.cooldown
		weapon.activate(owner, owner.nearest_enemy, get_tree())
