extends Node2D

func updateValue (value):
	var floatingValueLBL:Label = $HBoxContainer/value
	floatingValueLBL.text = str(value)
