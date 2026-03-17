#mendefinisikan class dengan nama EnemyStateDestroy dengan mewarisi EnemyState
class_name EnemyStateDestroy extends EnemyState


const PICKUP = preload("res://Items/item_pickup/item_pickup.tscn")

#mendeklarasikan anim_name dengan "destroy" 
@export var anim_name : String = "destroy"
#menentukan kecepatan knockback
@export var knockback_speed : float = 200.0
#mendeklarasikan pengurangan kecepatan knockback
@export var decelerate_speed : float = 10.0
#mendeklarasikan kategori "AI" di inspector
@export_category( "AI" )

@export_category( "Item Drops" )
@export var drops : Array[ DropData ]

#mengatur arah dorongan
var _direction : Vector2
#menentukan arah knockback
var _damage_position : Vector2

## What happens when we Initialize this state?
func init() -> void:
	#saat musuh emit sinyal destroy hubungkan dengan function _on_enemy_destroyed
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass

#function yang aktif saat state aktif
## What happens when the enemy enters this state?
func enter() -> void:
	#mengatur kekebalan musuh menjadi bernilai benar
	enemy.invulnerable = true
	#hitung arah dari enemy ke sumber damage
	_direction = enemy.global_position.direction_to( _damage_position )
	#menentukan arah
	enemy.set_direction( _direction )
	#dorong enemy ke arah berlawanan
	enemy.velocity = _direction * -knockback_speed
	#mengupdate animasi menjadi animasi state ini
	enemy.update_animation( anim_name )
	#saat animasi selesai hubungkan dengan function _on_animation_finished
	enemy.animation_player.animation_finished.connect( _on_animation_finished )
	disable_hurt_box()
	drop_items()
	pass

#function akan aktif saat state tidak aktif
## What happens when the enemy exits this state?
func exit() -> void:
	#putuskan hubungan dengan function _on_animation_finished
	enemy.animation_player.animation_finished.disconnect( _on_animation_finished )
	pass

#fungsi untuk proses update yang ada di state
## What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	#perlahan mengurangi knockback supaya berhenti natural
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

#fungsi untuk mengatur update fisik
## What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null


#function yang aktif saat menerima sinyal destroy
func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	#ambil posisi damage terakhir
	_damage_position = hurt_box.global_position
	#paksa fsm menjalankan state ini
	state_machine.change_state( self )


#function yang dijalankan saat animasi selesai
func _on_animation_finished( _a : String ) -> void:
	#node dihapus dari tree
	enemy.queue_free()


func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null( "HurtBox" )
	if hurt_box:
		hurt_box.monitoring = false


func drop_items() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[ i ] == null or drops[ i ].item == null:
			continue
		var drop_count : int = drops[ i ].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[ i ].item
			enemy.get_parent().call_deferred( "add_child", drop )
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated( randf_range( -1.5, 1.5 ) ) * randf_range( 0.9, 1.5 )
	pass
