extends Control

signal easy
signal hard
signal sound_change
signal quack_change

func _on_start_button_pressed():
	$Start.show()
	get_tree().call_group("handling_buttons", "hide")
	
func _on_easy_button_pressed():
	emit_signal("easy")

func _on_hard_button_pressed():
	emit_signal("hard")

func _on_credits_button_pressed():
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

func _on_options_button_pressed():
	$Options.show()
	get_tree().call_group("handling_buttons", "hide")

func _on_close_button_3_pressed():
	$Options.hide()
	get_tree().call_group("handling_buttons", "show")

func _on_sound_button_pressed():
	if $Options/Sound_Button/Sound_Value.text == "on":
		$Options/Sound_Button/Sound_Value.text = "off"
	else:
		$Options/Sound_Button/Sound_Value.text = "on"
	emit_signal("sound_change")

func _on_quack_button_pressed():
	if $Options/Quack_Button/Quack_Value.text == "on":
		$Options/Quack_Button/Quack_Value.text = "off"
	else:
		$Options/Quack_Button/Quack_Value.text = "on"
	emit_signal("quack_change")
