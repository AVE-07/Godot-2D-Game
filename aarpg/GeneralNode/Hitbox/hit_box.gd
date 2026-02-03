#setup core hitbox inherit dari Area2D
class_name HitBox extends Area2D

#digunakan saat hitbox terkena damage
signal Damaged( hurt_box : HurtBox )

#saat state dimulai fungsi ini aktif duluan
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#fungsi utama hitbox
func TakeDamage( hurt_box : HurtBox ) -> void:
	#saat terkena damage dia bakal mengeluarkan pemberitahuan
	Damaged.emit( hurt_box )
