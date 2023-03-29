extends Control

signal start

func _on_creadits_button_pressed():
	$Credits.show()
	get_tree().call_group("handling_buttons", "hide")

func _on_close_button_pressed():
	$Credits.hide()
	get_tree().call_group("handling_buttons", "show")

func _on_how_to_play_button_pressed():
	$HowToPlay.show()
	get_tree().call_group("handling_buttons", "hide")

func _on_close_button_2_pressed():
	$HowToPlay.hide()
	get_tree().call_group("handling_buttons", "show")
	
func _on_start_button_pressed():
	emit_signal("start")
