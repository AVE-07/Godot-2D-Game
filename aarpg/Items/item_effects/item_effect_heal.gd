#membuat class bernama ItemEffectHeal dengan mewarisi ItemEffect
class_name ItemEffectHeal extends ItemEffect

#membuat export untuk banyaknya heal diterima dan juga audio untuk suara pemakaian
@export var heal_amount : int = 1
@export var audio : AudioStream

#function yang aktif saat item dipakai
func use() -> void:
	#memangiil function update_hp dengan parameter heal_amount, untuk player di PlayerManager
	PlayerManager.player.update_hp( heal_amount )
	#memanggil function play_audio dengan parameter audio di PauseMenu
	PauseMenu.play_audio( audio )
