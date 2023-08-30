extends Control

signal prest_start

func set_high_score(value):
	$Panel/HighScore.text = "Hi-Score: " + str(value)


func _on_start_button_pressed():
	emit_signal("prest_start")
	hide()

