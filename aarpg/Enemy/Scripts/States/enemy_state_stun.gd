#mendefinisikan class dengan nama EnemyStateStun dengan mewarisi EnemyState
class_name EnemyStateStun extends EnemyState

#mendeklarasikan anim_name dengan "stun" 
@export var anim_name : String = "stun"
#mendeklarasikan kecepatan mundur saat terkena serangan
@export var knockback_speed : float = 200.0
#mendeklarasikan pengurangan kecepatan knockback
@export var decelerate_speed : float = 10.0
#mendeklarasikan kategori "AI" di inspector
@export_category( "AI" )
#state akan menyerahkan perannya ke state lain, diubah lewat inspector
@export var next_state : EnemyState
#menentukan arah knockback
var _damage_position : Vector2
#mengatur arah dorongan
var _direction : Vector2
#mengatur selesainya animasi state
var _animation_finished : bool = false

#state wonder tidak memerlukan setup global
## What happens when we Initialize this state?
func init() -> void:
	#saat musuh terkena damage fungsi _on_enemy_damaged akan terpanggil
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass

#function yang aktif saat state aktif
## What happens when the enemy enters this state?
func enter() -> void:
	#mengatur kekebalan supaya tidak bisa di hit beruntun
	enemy.invulnerable = true
	#reset status animasi saat stun aktif
	_animation_finished = false
	#hitung arah dari enemy ke sumber damage
	_direction = enemy.global_position.direction_to( _damage_position )
	#update arah
	enemy.set_direction( _direction )
	#dorong enemy ke arah berlawanan
	enemy.velocity = _direction * -knockback_speed
	#jalankan animasi state ini
	enemy.update_animation( anim_name )
	#setelah animasi selesai sambungkan ke function _on_animation_finished
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

#function akan aktif saat state tidak aktif
## What happens when the enemy exits this state?
func exit() -> void:
	#menonaktifkan kekebalan musuh
	enemy.invulnerable = false
	#setelah animasi selesai putuskan function _on_animation_finished
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

#fungsi untuk proses update yang ada di state
## What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	#jika animasi selesai benar maka lanjut ke state selanjutnya
	if _animation_finished == true:
		return next_state
	#perlahan mengurangi knockback supaya berhenti natural
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

#fungsi untuk mengatur update fisik
## What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null

#fungsi yang dipanggil saat terkena hit
func _on_enemy_damaged( hurt_box : HurtBox ) -> void:
	#simpan posisi serangan yang diterima
	_damage_position = hurt_box.global_position
	#paksa fsm menjalankan efek state ini
	state_machine.change_state( self )

#fungsi saat animasi selesai
func _on_animation_finished( _a : String ) -> void:
	#animasi selesai bernilai benar
	_animation_finished = true
