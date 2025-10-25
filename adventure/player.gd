# Player controller for Godot 4 (CharacterBody2D)
# Smooth walking with acceleration/deceleration and jump physics.
extends CharacterBody2D

@export_range(0.0, 2000.0, 1.0) var max_speed: float = 220.0
@export_range(0.0, 5000.0, 1.0) var accel: float = 2000.0
@export_range(0.0, 5000.0, 1.0) var friction: float = 1500.0
@export_range(0.0, 5000.0, 1.0) var gravity: float = 1100.0
@export_range(0.0, 2000.0, 1.0) var jump_velocity: float = 420.0
@export_range(0.0, 2.0, 0.01) var coyote_time: float = 0.12
@export var double_jump_enabled: bool = true
@export var walk_anim: StringName = "walk"
@export var idle_anim: StringName = "idle"
@export var jump_anim: StringName = "jump"

var velocity := Vector2.ZERO
var _coyote_timer := 0.0
var _can_double_jump := false

func _ready():
	# Add this node to "Player" group for enemy detection convenience
	if not is_in_group("Player"):
		add_to_group("Player")

func _physics_process(delta):
	_apply_gravity(delta)
	_process_horizontal_movement(delta)
	_process_jumping(delta)
	_apply_movement(delta)
	_update_animation()

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		_coyote_timer += delta
	else:
		velocity.y = 0 if velocity.y > 0 else velocity.y
		_coyote_timer = 0.0
		_can_double_jump = double_jump_enabled

func _process_horizontal_movement(delta):
	var input_dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var target := input_dir * max_speed
	# Smooth towards target speed
	if abs(target - velocity.x) < 1.0:
		velocity.x = target
	else:
		var change := accel * delta if abs(target) > abs(velocity.x) else friction * delta
		velocity.x = move_toward(velocity.x, target, change)

func _process_jumping(delta):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or _coyote_timer < coyote_time:
			velocity.y = -jump_velocity
			_can_double_jump = double_jump_enabled
		elif _can_double_jump:
			velocity.y = -jump_velocity * 0.9
			_can_double_jump = false

func _apply_movement(delta):
	# CharacterBody2D uses velocity and move_and_slide
	move_and_slide()

func _update_animation():
	var anim := $AnimatedSprite2D
	if not anim:
		return
	if not is_on_floor():
		anim.animation = jump_anim
	else:
		if abs(velocity.x) > 12.0:
			anim.animation = walk_anim
		else:
			anim.animation = idle_anim
	# Flip depending on direction
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0
