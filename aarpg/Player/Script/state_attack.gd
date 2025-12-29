#setup core state_idle extends sebagai state
class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animation_attack: AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

#referensi untuk transisi state ke state ini
@onready var run: State_Run = $"../Run"
@onready var idle: State_Idle = $"../Idle"

#saat state dimulai
## What happens when the player enters this state?
func Enter() -> void:
	#saat state dimulai animasi akan berubah menjadi "idle"
	player.UpdateAnimation("attack")
	animation_attack.play( "attack_" + player.AnimDirection() )
	animation_player.animation_finished.connect( EndAttack )
	audio.stream = attack_sound
	audio.pitch_scale = randf_range( 0.9, 1.1 )
	audio.play()
	attacking = true


#saat state keluar, bisa diubah kedepannya
## What happens when the player exits this state?
func Exit() -> void:
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	pass


#proses dalam state
## What happens during the _process update in this state?
func Process( _delta : float) -> State:
	#kecepatan = 0, karena idle itu animasi diam
	player.velocity -= player.velocity * decelerate_speed * _delta
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


func EndAttack( _newAnimName : String ) -> void:
	attacking = false
