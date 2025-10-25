# Level and spawning manager (can be autoloaded or placed in the main scene)
extends Node

@export var level_scenes: Array[PackedScene] = []
@export var enemy_scene: PackedScene
@export var trap_scene: PackedScene

var current_level := 0
var hud := null

func _ready():
	hud = get_tree().root.get_node("root/HUD") if get_tree().root.has_node("root/HUD") else null
	_load_level(current_level)

func _load_level(index):
	if index < 0 or index >= level_scenes.size():
		return
	# remove previous level children
	for c in get_children():
		if c.name.begins_with("LevelInstance"):
			c.queue_free()
	var level = level_scenes[index].instantiate()
	level.name = "LevelInstance_%d" % index
	add_child(level)
	if hud:
		hud.set_level_name("Stage %d" % (index + 1))
	# spawn example enemy/trap
	_spawn_enemy(level.get_node("EnemySpawner").global_position if level.has_node("EnemySpawner") else Vector2.ZERO)
	_spawn_trap(level.get_node("Trap1").global_position if level.has_node("Trap1") else Vector2.ZERO)

func _spawn_enemy(pos: Vector2):
	if not enemy_scene:
		return
	var e = enemy_scene.instantiate()
	e.position = pos
	add_child(e)

func _spawn_trap(pos: Vector2):
	if not trap_scene:
		return
	var t = trap_scene.instantiate()
	t.position = pos
	add_child(t)

func next_level():
	current_level += 1
	if current_level >= level_scenes.size():
		current_level = 0
	_load_level(current_level)