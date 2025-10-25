# Helper API functions you should add to your player scene so enemies/traps can call them.
extends Node

var max_health := 5
var health := 5

func take_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	# emit signal or update HUD
	if has_node("/root/HUD"):
		get_node("/root/HUD").set_health(health)
	# optional knockback or death handling
	if health <= 0:
		_die()

func _die():
	# Basic death handler. Replace with desired logic.
	queue_free()