#setup core plant inherit dari Node2D
class_name Plant extends Node2D


#saat node aktif fungsi ini akan jalan pertama kali
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#mengkoneksikan signal yang diterima hitbox dan diaktifkan di fungsi TakeDamage di plant
	$HitBox.Damaged.connect( TakeDamage )
	pass # Replace with function body.


#fungsi yang aktif saat menerima signal kalo hitbox diserang
func TakeDamage( _damage : int ) -> void:
	#fungsi yang aktif saat terkena seranga
	#fungsi ini langsung menghapus entitas plant di map (kill)
	queue_free()
	pass
