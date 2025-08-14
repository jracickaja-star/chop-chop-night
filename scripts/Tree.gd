extends Node2D

var size := 0.8     # 0.5..1.5 grows over time
var hp := 3         # chops required; resets on regrow
const MAX_SIZE := 1.6
const MIN_SIZE := 0.6

func _ready() -> void:
    _update_visual()

func _process(delta: float) -> void:
    # Grow faster at day, slower at night
    var rate := lerp(0.01, 0.10, GameState.daylight_factor())
    size = clamp(size + rate * delta, MIN_SIZE, MAX_SIZE)
    if size >= MAX_SIZE and hp < 3:
        hp = 3
    _update_visual()

func chop_once() -> int:
    # Return logs gained
    if size < 0.7: return 0
    hp -= 1
    var logs := (size > 1.2) ? 2 : 1
    size = max(MIN_SIZE, size - 0.15)
    if hp <= 0:
        logs += 2
        size = 0.6
        hp = 3
    _update_visual()
    return logs

func _update_visual() -> void:
    queue_redraw()

func _draw() -> void:
    draw_rect(Rect2(Vector2(-4, -20), Vector2(8, 20)), Color(0.35, 0.2, 0.1))
    var r := 20.0 * size
    draw_circle(Vector2(0, -30), r, Color(0.1, 0.5, 0.2))
