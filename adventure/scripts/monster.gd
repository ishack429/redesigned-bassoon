extends CharacterBody2D

@export var patrol_speed := 60.0
@export var chase_speed := 140.0
@export var chase_distance := 220.0
@export var damage := 1
@export var patrol_points := [Vector2(-120,0), Vector2(120,0)]

var origin := Vector2.ZERO
var idx := 0
var velocity := Vector2.ZERO
var chasing := false
onready var player := null
onready var anim := $AnimatedSprite2D

func _ready():
    origin = global_position
    if get_tree().has_current_scene():
        player = get_tree().get_root().get_node_or_null("/root/Game/player")
    anim.play("idle")

func _physics_process(delta):
    if not player:
        player = get_tree().get_root().get_node_or_null("/root/Game/player")
    var to_player = player ? player.global_position - global_position : Vector2.INF

    if player and to_player.length() <= chase_distance:
        chasing = true
    elif chasing and player and to_player.length() > chase_distance * 1.2:
        chasing = false

    if chasing and player:
        _chase(player.global_position, delta)
    else:
        _patrol(delta)

    move_and_slide(velocity)

func _patrol(delta):
    var target = origin + patrol_points[idx]
    var dir = (target - global_position)
    if dir.length() < 6:
        idx = (idx + 1) % patrol_points.size()
        return
    var dirn = dir.normalized()
    velocity.x = dirn.x * patrol_speed
    anim.play("walk")

func _chase(target_pos: Vector2, delta):
    var dir = (target_pos - global_position).normalized()
    velocity.x = dir.x * chase_speed
    anim.play("run")

func _on_body_entered(body):
    if body.is_in_group("player"):
        if body.has_method("damage"):
            body.damage(damage, Vector2(sign(velocity.x)*120, -180))
