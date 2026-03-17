#memberi nama class InventorySlotUI dengan mewarisi Button
class_name InventorySlotUI extends Button

#var slot_data untuk menampung SlotData lalu menggunakan setter untuk mengubah otomatis
var slot_data : SlotData : 
	set = set_slot_data

#referensi untuk texture kotak dan label
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

#function yang aktif saat node pertama kali masuk kedalam scene tree
func _ready() -> void:
	#mengosongkan gambar saat inisialisasi awal
	texture_rect.texture = null
	#mengosongkan label teks saat insialisasi awal
	label.text = ""
	#menghubungkan sinyal focus_entered (navigasi keyboard/controller) kedalam function item_focused
	focus_entered.connect( item_focused )
	#menghubungkan sinyal focus_exited (navigasi keyboard/controller) kedalam function item_unfocused
	focus_exited.connect( item_unfocused )
	#menghubungkan pressed (tombol ditekan) kedalam function item_pressed
	pressed.connect( item_pressed )

#function yang aktif untuk memperbaruhi value setter dengan paramater value dari SlotData
func set_slot_data( value : SlotData ) -> void:
	#mengatur nilai slot_data dengan value
	slot_data = value
	#jika slot_data kosong
	if slot_data == null:
		#hentikan function
		return
	#mengambil texture (gambar) dari item_data dan ditaruh di texture_rect
	texture_rect.texture = slot_data.item_data.texture
	#mengubah angka quantity di slot_data menjadi string dan menampilkannya di label
	label.text = str( slot_data.quantity )

#function yang aktif saat player menghover item dengan cursor
func item_focused() -> void:
	#jika slot_data tidak kosong (null)
	if slot_data != null:
		#jika item_data di slot_data tidak kosong (null)
		if slot_data.item_data != null:
			#mengirim deskrip item ke PauseMenu untuk ditampilkan
			PauseMenu.update_item_description( slot_data.item_data.description )
	pass

#function yang aktif saat player berhenti menghover item
func item_unfocused() -> void:
	#mengubah deskripsi item di PauseMenu menjadi kosong ( "" )
	PauseMenu.update_item_description( "" )
	pass

#function yang aktif saat player menekan tombol
func item_pressed() -> void:
	#mengecek apakah ada data, jika slot_data
	if slot_data:
		#mengecek apakah ada item di slot_data, jika ada item_data di slot_data
		if slot_data.item_data:
			#menjalankan function use di item dan menyimpan di var was_used
			var was_used =slot_data.item_data.use()
			#jika was_used tidak memiliki efek (item bukan cosumable)
			if was_used == false:
				#hentikan function
				return
			#kurangi item tersebut, berkurang 1 setiap pemakaian
			slot_data.quantity -= 1
			#menampilkan tulisan jumlah item yang tersisa
			label.text = str( slot_data.quantity )
