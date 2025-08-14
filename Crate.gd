extends Node2D

func deposit(amount: int) -> int:
    var space := GameState.CRATE_CAPACITY - GameState.crate_wood
    if space <= 0: return 0
    var moved := min(space, amount)
    GameState.crate_wood += moved
    return moved

func _draw() -> void:
    draw_rect(Rect2(Vector2(-12, -12), Vector2(24, 24)), Color(0.5, 0.35, 0.2))