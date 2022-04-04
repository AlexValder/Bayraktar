extends Node

const MAIN_MENU := "main_menu"
const LEVEL_01 := "level02"
var _scenes := {
    MAIN_MENU : "res://Scenes/MainMenu.tscn",
    LEVEL_01 : "res://Scenes/Level01.tscn",
   }
var _current: String = MAIN_MENU
onready var _node := $"../MainMenu"


func _ready() -> void:
    prepare_game()


func change_level(to: String) -> void:
    _current = to

    var tree := get_tree().get_root()
    if _node != null:
        tree.remove_child(_node)
        _node.queue_free()

    _node = (load(_scenes[_current]) as PackedScene).instance()
    tree.add_child(_node)


func prepare_game() -> void:
    _setup_window()


func _setup_window() -> void:
    OS.window_fullscreen = true


func graceful_exit() -> void:
    get_tree().quit(0)
