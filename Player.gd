extends CharacterBody2D

@export var speed := 180.0

func _physics_process(delta: float) -> void:
    var v := Vector2.ZERO
    if Input.is_action_pressed("ui_right"): v.x += 1
    if Input.is_action_pressed("ui_left"):  v.x -= 1
    if Input.is_action_pressed("ui_down"):  v.y += 1
    if Input.is_action_pressed("ui_up"):    v.y -= 1
    velocity = v.normalized() * speed
    move_and_slide()

    if Input.is_action_just_pressed("interact"):
        _try_chop_tree()
    if Input.is_action_just_pressed("feed_fire"):
        _try_feed_fire()
    if Input.is_action_just_pressed("deposit"):
        _try_deposit()

func _try_chop_tree() -> void:
    var tree := _find_nearest_node_with_script("Tree.gd", 48.0)
    if tree:
        var logs := tree.call("chop_once")
        if logs > 0:
            GameState.player_wood += logs

func _try_feed_fire() -> void:
    if GameState.player_wood <= 0: return
    var fire := _find_nearest_node_with_script("Campfire.gd", 64.0)
    if fire and fire.call("feed", 1):
        GameState.player_wood -= 1

func _try_deposit() -> void:
    if GameState.player_wood <= 0: return
    var crate := _find_nearest_node_with_script("Crate.gd", 64.0)
    if crate:
        var moved := crate.call("deposit", GameState.player_wood)
        GameState.player_wood -= moved

func _find_nearest_node_with_script(script_name: String, radius: float) -> Node:
    var scene := get_tree().current_scene
    var best: Node = null
    var best_d := radius
    for n in scene.get_children():
        if n is Node2D:
            for c in n.get_children():
                if c.get_script() and c.get_script().resource_path.ends_with(script_name):
                    var d := (c.global_position - global_position).length()
                    if d <= best_d:
                        best_d = d; best = c
        if n.get_script() and n.get_script().resource_path.ends_with(script_name):
            var d2 := (n.global_position - global_position).length() if n.has_method("get_global_position") else 9999
            if d2 <= best_d: best_d = d2; best = n
    return best