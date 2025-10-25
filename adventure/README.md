# Adventure Stage Additions (copilot/adventure-stages)

These files implement:
- Smooth player movement & animations (adventure/player.gd)
- Patrol/chase enemy behavior (adventure/enemy.gd)
- Trap behavior (saw/spikes) (adventure/trap.gd)
- Basic HUD (adventure/ui/HUD.gd)
- Game manager (adventure/game_manager.gd)
- Example Level scene (adventure/level1.tscn)

Integration notes:
1. Input map:
   - Ensure these actions exist in Project Settings > Input Map:
     - "ui_left", "ui_right", "jump"
2. Player scene:
   - Create a CharacterBody2D scene with an AnimatedSprite2D node named "AnimatedSprite2D".
   - Attach adventure/player.gd to the CharacterBody2D.
   - Make sure the player scene provides a `take_damage(amount)` method (player_api.gd), or merge that API into your player.
3. Enemy and trap:
   - Create PackedScenes for enemy & trap (CharacterBody2D with AnimatedSprite2D for enemy; Node2D with Area2D for trap), then set GameManager exports accordingly to spawn them.
4. HUD:
   - Add the HUD scene (CanvasLayer) as a child of the root. Connect the pause/other UI controls as needed.
5. Scenes & Assets:
   - The Level tscn references some imported textures already present in the repo (the /adventure/.godot/imported/ folder). Update paths to match actual resource names in your project.

If you'd like, I will:
- Push these files to branch `copilot/adventure-stages` and open a pull request.
- Or I can push only a subset, or refine animations and wire up actual sprites/AnimatedSprite2D frames.

Say "Push and PR" to have me commit these and open a PR, or say "Refine" and tell me which parts to polish first.