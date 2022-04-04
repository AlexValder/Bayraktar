extends Control


func _on_StartButton_button_up():
    GameManager.change_level(GameManager.LEVEL_01)


func _on_ExitButton_button_up():
    GameManager.graceful_exit()
