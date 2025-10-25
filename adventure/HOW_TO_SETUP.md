How to set up these files in the Godot project (summary)

1) Add the scripts under adventure/scripts/ as shown (player.gd, monster.gd, trap.gd, game.gd).
2) Create scenes:
   - Player.tscn: CharacterBody2D root with AnimatedSprite2D named AnimatedSprite2D, CollisionShape2D, and attach player.gd. Add group "player".
   - Monster.tscn: CharacterBody2D root, AnimatedSprite2D, CollisionShape2D, attach monster.gd.
   - Trap.tscn: Area2D root with CollisionShape2D and attach trap.gd.
   - HUD.tscn: CanvasLayer with VBoxContainer and Labels, attach hud.gd.
3) Project settings:
   - Input Map: ui_left (A/Left), ui_right (D/Right), ui_accept (Space), ui_cancel (Esc)
   - AutoLoad: add adventure/scripts/game.gd as "Game"
4) Place Player, Monster, Trap and HUD in a Level1.tscn or similar scene. Wire signals:
   - Monster body_entered -> _on_body_entered
   - Trap body_entered is already connected in trap.gd
5) Testing:
   - Run the Level1.tscn, confirm player acceleration feels smooth, collisions with traps and monsters cause damage/knockback.
