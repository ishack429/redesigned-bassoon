extends CharacterBody2D

@export var speed: float = 220.0
@export var accel: float = 1200.0
@export var friction: float = 1200.0
@export var gravity: float = 1000.0
@export var jump_velocity: float = -420.0
@export var max_fall_speed: float = 900.0
@export var max_health: int = 5

var velocity := Vector2.ZERO
var facing_right := true
var health: int

onready var anim: AnimatedSprite2D = $AnimatedSprite2D
onready var sprite: Sprite2D = $AnimatedSprite2D
onready var hitbox: CollisionShape2D = $CollisionShape2D

func _ready():
    health = max_health
    anim.play("idle")

func _physics_process(delta):
    _apply_gravity(delta)
    _process_input(delta)
    _apply_motion(delta)
    _update_animation()

func _apply_gravity(delta):
    if not is_on_floor():
        velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

func _process_input(delta):
    var input_dir := 0
    if Input.is_action_pressed("ui_right"):
        input_dir += 1
    if Input.is_action_pressed("ui_left"):
        input_dir -= 1

    # smooth acceleration
    var target_speed = input_dir * speed
    if abs(target_speed - velocity.x) < 1.0:
        velocity.x = target_speed
    else:
        if target_speed > velocity.x:
            velocity.x = min(velocity.x + accel * delta, target_speed)
        elif target_speed < velocity.x:
            velocity.x = max(velocity.x - accel * delta, target_speed)

    # friction when no input
    if input_dir == 0 and is_on_floor():
        if abs(velocity.x) < 10:
            velocity.x = 0
        elif velocity.x > 0:
            velocity.x = max(velocity.x - friction * delta, 0)
        else:
            velocity.x = min(velocity.x + friction * delta, 0)

    # jump
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = jump_velocity
        anim.play("jump")

func _apply_motion(delta):
    velocity = move_and_slide(velocity, Vector2.UP)

func _update_animation():
    if not is_on_floor():
        anim.play("jump")
    elif abs(velocity.x) > 20:
        anim.play("run")
    else:
        anim.play("idle")

    if velocity.x > 1:
        facing_right = true
    elif velocity.x < -1:
        facing_right = false
    $AnimatedSprite2D.flip_h = not facing_right

# Damage API
func damage(amount: int, knockback: Vector2 = Vector2.ZERO):
    health = max(health - amount, 0)
    # apply a small knockback
    velocity += knockback
    if health <= 0:
        _die()

func _die():
    anim.play("dead")
    set_physics_process(false)
    # optional: emit a signal to the game manager
    if has_node("/root/Game"):
        get_node("/root/Game").call_deferred("on_player_died")
