extends Node2D

func updateValue (value, color:Color):
	var floatingValueLBL:Label = $HBoxContainer/value
	var valueSign:Label = $HBoxContainer/Sign
	floatingValueLBL.label_settings.font_color = color
	valueSign.label_settings.font_color = color

	if not color == Color.RED:
		valueSign.text = "+"

	floatingValueLBL.text = str(value)
