#membuat class dengan nama HeartGUI dengan mewarisi control
#control = bisa di dock, punya layout, bisa overlay layar
class_name HeartGUI extends Control

#membuat referensi
#referensi untuk sprite untuk heart
@onready var sprite: Sprite2D = $Sprite2D

#mendeklarasikan value dengan int bernilai 2
var value : int = 2 :
	#property setter
	#misal jika set value menjadi 1, karena value = _value, maka sprite akan berubah sesuai setter
	set( _value ):
		value = _value
		update_sprite()

#function yang jalan sesuai value
func update_sprite() -> void:
	#mengatur frame sesuai value
	sprite.frame = value
