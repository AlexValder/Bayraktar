extends Node

const CAMERA_WIDTH = 1024
const CAMERA_HEIGHT = 576
const WIDTH = CAMERA_WIDTH / 32
const HEIGHT = CAMERA_HEIGHT / 32
onready var _tileMap := $level/TileMap as TileMap
onready var _spawn1 := $level/Spawn1 as Position2D
onready var _spawn2 := $level/Spawn2 as Position2D
onready var _camera := $Camera2D as Camera2D
onready var _tank := preload("res://Assets/Objects/Tank.tscn") as PackedScene


func _ready() -> void:
    randomize()
    _create_field()


func _create_field() -> void:
    _tileMap.clear()
    _prepare_grass()
    var pos := _draw_road()
    _spawn1.position = pos[0]
    _spawn1.position.y -= 5
    _spawn2.position = pos[1]
    _spawn2.position.y -= 5


func _prepare_grass() -> void:
    var grass := _get_grass_tiles()
    for x in range(WIDTH):
        for y in range(HEIGHT):
            _tileMap.set_cell(
                x,
                y,
                grass[randi() % grass.size()],
                randi() % 2
            )


func _draw_road() -> Array:
    var set := _tileMap.tile_set
    var roads := _get_road_tiles()
    var y := 0
    while y < HEIGHT:
        var road := roads[randi() % roads.size()]
        _place_road_autotile(WIDTH / 2 - 4, y, road)
        _place_road_autotile(WIDTH / 2 + 3, y, road)
        y += 2
    return [
        _tileMap.map_to_world(Vector2(WIDTH / 2 - 3, 0)),
        _tileMap.map_to_world(Vector2(WIDTH / 2 + 4, 0)),
    ]

func _place_road_autotile(x: int, y: int, id: int) -> void:
    _tileMap.set_cell(x, y, id, false, false, false, Vector2(0, 0))
    _tileMap.set_cell(x, y + 1, id, false, false, false, Vector2(0, 1))
    _tileMap.set_cell(x + 1, y, id, false, false, false, Vector2(1, 0))
    _tileMap.set_cell(x + 1, y + 1, id, false, false, false, Vector2(1, 1))



func _get_grass_tiles() -> PoolIntArray:
    return _get_tiles_by_prefix("grass_")


func _get_road_tiles() -> PoolIntArray:
    return _get_tiles_by_prefix("road_")


func _get_tiles_by_prefix(prefix: String) -> PoolIntArray:
    var set := _tileMap.tile_set
    var array := set.get_tiles_ids()
    var result := []
    for i in array.size():
        var name := set.tile_get_name(i)
        if name.begins_with(prefix):
            result.append(i)
    return PoolIntArray(result)


func _on_Button_button_up():
    GameManager.change_level(GameManager.MAIN_MENU)


func _on_SpawnTimer_timeout():
    if randi() % 2 == 0:
        _spawn_tank(_spawn1, 10)
    else:
        _spawn_tank(_spawn2, 10)


func _spawn_tank(pos: Position2D, speed: float) -> void:
    var tank := _tank.instance()
    add_child(tank)
    tank.position = pos.position
    tank.start_move(speed)
