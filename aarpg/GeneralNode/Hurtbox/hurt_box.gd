#setup core hurtbox inherit dari Area2D
class_name HurtBox extends Area2D

#jumlah damage yang diberikan (dengan export bisa diatur di inspector)
@export var damage : int = 1

#aktif pertama kali saat scene tree aktif
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#area_entered akan kepanggil saat area2d hurtbox overlap dengan area2d yang lain (hitbox, dll)
	area_entered.connect( AreaEntered )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#fungsi yang akan aktif saat hurtbox overlap area2d lain
func AreaEntered( a : Area2D ) -> void:
	#mengecek apakah area2d yang bersentuhan adalah hitbox
	if a is HitBox:
		#jika benar maka akan terkena damage dari jumlah damage yang ditentukan
		#dan hitbox akan mengeluarkan sinyal dengan menjalankan fungsi TakeDamage
		a.TakeDamage( damage )
	pass
