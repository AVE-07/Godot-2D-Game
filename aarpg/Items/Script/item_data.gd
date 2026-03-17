#membuat class bernama ItemData yang mewarisi Resource
class_name ItemData extends Resource

#membuat export (inspector) untuk nama, deskripsi dan texture
@export var name : String = ""
@export_multiline var description : String = ""
@export var texture : Texture2D

#membuat kategori baru di inspector
@export_category( "Item Use Effects" )
#membuat export (inspector) untuk effect
@export var effects: Array[ ItemEffect ]

#function yang dijalankan saat pemakaian item
func use() -> bool:
	#jika jumlah item sama setara dengan 0, maka batalkan penggunaan efek
	if effects.size() == 0:
		return false
	#melakukan perulang untuk e di effect
	for e in effects:
		#memastikan jika item ada efeknya, jika e
		if e:
			#maka menjalankan function use() di setiap e
			e.use()
	#lalu mengembalikan nilai true untuk pengaktifan efek
	return true
