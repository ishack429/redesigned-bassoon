extends Node

var player := null
var score := 0

func _ready():
    player = get_tree().get_root().get_node_or_null("/root/CurrentScene/Player")

func register_player(p):
    player = p
    self.player = p
    if has_node("player") == false:
        set("player", player)

func add_score(amount: int):
    score += amount
    if get_node_or_null("/root/CurrentScene/HUD"):
        get_node("/root/CurrentScene/HUD").call_deferred("update_score", score)

func on_player_died():
    print("Player died - Game.on_player_died called")