extends Node

# --- Time & Temperature ---
const DAY_LENGTH_SEC := 120.0  # full cycle day->night->day = 120s
var time_sec: float = 0.0      # increments; modulo DAY_LENGTH_SEC
var temperature: float = 20.0  # comfortable day start
const MIN_TEMP := -5.0         # safety floor
const GAME_OVER_TEMP := 0.0

# Night cooling and day warming rates (per second)
const COOL_RATE := 0.15
const WARM_RATE := 0.10

# Heat contributed by campfire when burning
var campfire_heat: float = 0.0 # set by Campfire.gd when active

# --- Resources ---
var player_wood: int = 0
var crate_wood: int = 0
const CRATE_CAPACITY := 50

# Signals
signal game_over

func _process(delta: float) -> void:
    time_sec = fmod(time_sec + delta, DAY_LENGTH_SEC)
    _update_temperature(delta)
    _update_hud()
    if temperature <= GAME_OVER_TEMP:
        emit_signal("game_over")

func is_daytime() -> bool:
    return time_sec < DAY_LENGTH_SEC * 0.5

func daylight_factor() -> float:
    var phase := (time_sec / DAY_LENGTH_SEC) * TAU
    return clamp(0.5 + 0.5 * sin(phase), 0.0, 1.0)

func _update_temperature(delta: float) -> void:
    if is_daytime():
        temperature += WARM_RATE * delta
    else:
        temperature -= COOL_RATE * delta
    # Campfire adds heat when burning (only meaningful at night)
    temperature += campfire_heat * delta
    temperature = clamp(temperature, MIN_TEMP, 40.0)

func _update_hud() -> void:
    var root := get_tree().current_scene
    if not root: return
    var hud := root.get_node_or_null("CanvasLayer/HUD")
    if not hud: return
    hud.get_node("TempLabel").text = "Temp: %.1f°C%s" % [temperature, is_daytime() ? " (Day)" : " (Night)"]
    hud.get_node("TimeLabel").text = "Time: %d/%ds" % [int(time_sec), int(DAY_LENGTH_SEC)]
    hud.get_node("WoodLabel").text = "Wood: %d (Inv) | Crate: %d" % [player_wood, crate_wood]