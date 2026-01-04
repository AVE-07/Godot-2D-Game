#setup core hitbox inherit dari Area2D
class_name HitBox extends Area2D

#digunakan saat hitbox terkena damage
signal Damaged( damage : int )

#saat state dimulai fungsi ini aktif duluan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#fungsi utama hitbox
func TakeDamage( damage : int ) -> void:
	#debugging untuk ngecek terpanggil atau tidak
	print( "TakeDamage: ", damage )
	#saat terkena damage dia bakal mengeluarkan pemberitahuan
	Damaged.emit( damage )
