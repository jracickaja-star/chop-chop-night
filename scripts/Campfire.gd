extends Node2D

var burning := false
var burn_timer := 0.0
const BURN_PER_LOG_SEC := 15.0   # each log burns for 15s
const HEAT_STRENGTH := 0.25      # heat per second added to temperature

func _process(delta: float) -> void:
    if burning:
        burn_timer -= delta
        GameState.campfire_heat = HEAT_STRENGTH if not GameState.is_daytime() else 0.0
        if burn_timer <= 0.0:
            burning = false
            GameState.campfire_heat = 0.0
    queue_redraw()

func feed(logs: int) -> bool:
    if logs <= 0: return false
    burning = true
    burn_timer += BURN_PER_LOG_SEC * logs
    return true

func _draw() -> void:
    var c := burning and not GameState.is_daytime() ? Color(1,0.4,0.1) : Color(0.3,0.3,0.3)
    draw_circle(Vector2.ZERO, 10, c)
