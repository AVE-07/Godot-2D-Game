#mendefinisikan class dengan nama EnemyStateWonder dengan mewarisi EnemyState
class_name EnemyStateDestroy extends EnemyState

#mendeklarasikan anim_name dengan "destroy" 
@export var anim_name : String = "destroy"
#mendeklarasikan kecepatan
@export var knockback_speed : float = 200.0
#mendeklarasikan pengurangan kecepatan
@export var decelerate_speed : float = 10.0
#mendeklarasikan kategori "AI" di inspector
@export_category( "AI" )
#mengatur arah awal state
var _direction : Vector2
var _damage_position : Vector2

#state wonder tidak memerlukan setup global
## What happens when we Initialize this state?
func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass

#function yang aktif saat state aktif
## What happens when the enemy enters this state?
func enter() -> void:
	enemy.invulnerable = true
	_direction = enemy.global_position.direction_to( _damage_position )
	#menentukan arah
	enemy.set_direction( _direction )
	#menentukan gerak fisik
	enemy.velocity = _direction * -knockback_speed
	#menentukan anim_name yang dideklarasikan di awal
	enemy.update_animation( anim_name )
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	pass

#function akan aktif saat state tidak aktif
## What happens when the enemy exits this state?
func exit() -> void:
	pass

#fungsi untuk proses update yang ada di state
## What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

#fungsi untuk mengatur update fisik
## What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null


func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state( self )


func _on_animation_finished( _a : String ) -> void:
	enemy.queue_free()
