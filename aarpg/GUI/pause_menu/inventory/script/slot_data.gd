#memberikan nama class SlotData dengan mewarisi Resource
class_name SlotData extends Resource

#membuat variabel export untuk menyimpan data item yang ada di ItemData
@export var item_data : ItemData
#membuat variabel export untuk menyimpan data quantity item, dan memakai setter untuk memperbarui otomatis
@export var quantity : int = 0:
	set = set_quantity

#function yang dipakai untuk mengatur otomatis jumlah item
func set_quantity( value : int = 1 ) -> void:
	#ubah nilai value menjadi nilai quantity
	quantity = value
	#jika quantity lebih dari 1
	if quantity < 1:
		#keluarkan sinyal changed
		emit_changed()
