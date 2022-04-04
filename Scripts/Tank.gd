extends Node2D
class_name Tank

var _moving := false
var _speed := 0.0
onready var _mesh := $MeshInstance2D as MeshInstance2D

func _ready() -> void:
    var image := preload("res://Assets/Sprites/Tiles/tank.png") as StreamTexture
    image.flags = image.FLAGS_DEFAULT
    _mesh.texture = image


func _process(delta: float) -> void:
    if !_moving:
        return

    translate(Vector2(0, _speed * delta))
    print(position)


func start_move(speed: float) -> void:
    _speed = speed
    _moving = true
