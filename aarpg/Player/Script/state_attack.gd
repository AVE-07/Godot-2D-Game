#setup core state_attack inherit dari state
class_name State_Attack extends State

#membuat variabel attacking
var attacking : bool = false

#membuat variabel untuk sound attack
@export var attack_sound : AudioStream
#membuat var yang akan digunakan untuk mengurangi kecepatan player saat attack
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

#mempersiapkan animasi chracter, effect dan juga suara
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_attack: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

#referensi untuk transisi state ke state ini
@onready var run: State_Run = $"../Run"
@onready var idle: State_Idle = $"../Idle"
@onready var hurt_box: HurtBox = %AttackHurtBox


#saat state dimulai
## What happens when the player enters this state?
func Enter() -> void:
	#saat state dimulai animasi akan berubah menjadi "attack"
	player.UpdateAnimation("attack")
	#memainkan animasi attack sesuai arah karakter 
	animation_attack.play( "attack_" + player.AnimDirection() )
	#setelah animasi attack selesai akan di hubungkan ke endattack
	animation_player.animation_finished.connect( EndAttack )
	#memberi node di scene tree dengan sound
	audio.stream = attack_sound
	#membuat range suara audio attack diantara 0.9 sampai 1.1
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	#memulai audio attack
	audio.play()
	#mengubah nilai attacking jadi true
	attacking = true
	#membuat delay code untuk aktif setelah 0.075 detik
	await get_tree().create_timer( 0.075 ).timeout
	#mengaktifkan fungsi monitoring hurtbox yang ada di inpector
	hurt_box.monitoring = true


#saat state keluar, bisa diubah kedepannya
## What happens when the player exits this state?
func Exit() -> void:
	#setelah keluar dari attack memutus sinyal, supaya animasi tidak aktif saat animasi lain
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	#mematikan fungsi monitoring yang ada di inspector
	hurt_box.monitoring = false
	pass


#proses dalam state
## What happens during the _process update in this state?
func Process( _delta : float) -> State:
	#mengurangi velocity saat attack supaya attacknya menjadi slide sedikit
	player.velocity -= player.velocity * decelerate_speed * _delta
	#kalau var attacking bernilai false disertai karakter diam, maka menjadi idle, kalo tidak run
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return null


## What happens during the _physic_process update in this state?
func Physic( _delta : float) -> State:
	return null

## What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null

#mengatur saat attack selesai
func EndAttack( _newAnimName : String ) -> void:
	#membuat value attacking menjadi false
	attacking = false
