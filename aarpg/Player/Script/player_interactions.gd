#setup core interaksi player inherit dari Node2D
class_name PlayerInteractions extends Node2D

#menyiapkan referensi 
@onready var player: Player = $".."


#saat node diaktifkan pertama kali fungsi ini akan aktif duluan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mengkoneksikan sinyal yang diterima dari player dan menjalankan fungsi UpdateDirection
	player.DirectionChange.connect( UpdateDirection )
	pass # Replace with function body.

#fungsi yang aktif saat player mengganti arah
func UpdateDirection( new_direction : Vector2 ) -> void:
	#use case versi godot, mengubah arah dengan arah yang diterima dari sinyal player
	match new_direction:
		#mengubah arah hurtbox
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass
