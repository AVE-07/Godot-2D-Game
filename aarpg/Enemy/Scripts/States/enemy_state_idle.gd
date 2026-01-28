#mendefinisikan class deangan nama EnemyStateIdle dengan mewariskan EnemyState
class_name EnemyStateIdle extends EnemyState

#memberi nama anim_name dengan "idle" dan diatruh di inspector
@export var anim_name : String = "idle"
#memuat kategori baru bernama "AI" di inspector
@export_category( "AI" )
#mengatur durasi suatu state
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
#setelah durasi state habis dia akan menyerahkan kontrol ke state lain melalui inspcetor
@export var after_idle_state : EnemyState
#menyetel timer awal untuk state ini
var _timer : float = 0.0

#state idle tidak memerlukan setup global ini jadi diskip
## What happens when we Initialize this state?
func init() -> void:
	pass

#func yang aktif saat state aktif
## What happens when the enemy enters this state?
func enter() -> void:
	#membuat entitas enemy tidak bergerak
	enemy.velocity = Vector2.ZERO
	#menentukan lamanya durasi state idle ini aktif
	_timer = randf_range( state_duration_min, state_duration_max )
	#mengupdate animasi sesuai dengan anim_name yang dideklarasikan di awal
	enemy.update_animation( anim_name )
	pass

#func akan aktif saat state sudah tidak aktif
## What happens when the enemy exits this state?
func exit() -> void:
	pass

#fungsi untuk proses update yang ada di state
## What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	#jika durasi state habis maka state akan langsung exit(), jika durasi masih ada state tetap aktif
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null

#func untuk state idle tidak digunakan karena idle tidak bergerak
## What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null
