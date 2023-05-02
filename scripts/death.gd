extends Control

signal start_over # az avval bazi konim?

#age dokme safhe "you died!" ro zadim...
func _on_death_menu_button_pressed():
	emit_signal("start_over") # ...signal ro emit kone ke oonvar start konim
