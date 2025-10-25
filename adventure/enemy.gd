# Basic enemy with patrol + chase behavior for Godot 4 (CharacterBody2D)
extends CharacterBody2D

@export var patrol_distance: float = 160.0
@export var speed: float = 110.0
@export var chase_speed: float = 170.0
@export var detection_radius: float = 220.0
@export var damage_on_contact: int = 1

var _origin := Vector2.ZERO
var _direction := 1
var _state := "patrol" # other state: "chase"
var _player_ref := null

func _ready():
	_origin = global_position
	# optionally add to group
	add_to_group("Enemies")

func _physics_process(delta):
	_find_player()
	match _state:
		"patrol":
			_patrol(delta)
		"chase":
			_chase(delta)
	_update_animation()

func _find_player():
	# simple nearest player detection using group
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() == 0:
		_state = "patrol"
		_player_ref = null
		return
	var p = players[0]
	var d = p.global_position.distance_to(global_position)
	if d <= detection_radius:
		_state = "chase"
		_player_ref = p
	else:
		_state = "patrol"
		_player_ref = null

func _patrol(delta):
	var target_x = _origin.x + _direction * patrol_distance
	var dir = sign(target_x - global_position.x)
	velocity.x = dir * speed
	# change direction when close to waypoint
	if abs(global_position.x - target_x) < 6.0:
		_direction *= -1
	velocity = move_and_slide()

func _chase(delta):
	if not _player_ref:
		_state = "patrol"
		return
	var dir = sign(_player_ref.global_position.x - global_position.x)
	velocity.x = dir * chase_speed
	velocity = move_and_slide()

func _on_body_entered(body):
	# damage player if body is in Player group
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage_on_contact)

func _update_animation():
	if $AnimatedSprite2D:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		if _state == "chase":
			$AnimatedSprite2D.animation = "run"
		else:
			$AnimatedSprite2D.animation = "patrol"