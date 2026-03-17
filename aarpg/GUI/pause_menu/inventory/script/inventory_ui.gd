#memberi nama class InventoryUI dengan mewarisi Control
class_name InventoryUI extends Control

#memuat template (scene) slot inventaris secara instan menggunakan resource UID
const INVENTORY_SLOT = preload( "uid://dr2o0r1ocwsg4" ) 
#var untuk melacak index mana yang sedang di hover oleh player
var focus_index : int = 0
#var untuk mengekspor InventoryData ke UI
@export var data : InventoryData

#function yang aktif saat node pertama kali masuk kedalam scene tree
func _ready() -> void:
	#menghubungkan signal shown yang ada di PauseMenu ke dalam function update_inventory
	PauseMenu.shown.connect( update_inventory )
	#menghubungkan signal hidden yang ada di PauseMenu ke dalam function clear_inventory
	PauseMenu.hidden.connect( clear_inventory )
	#menjalankan function clear_inventory()
	clear_inventory()
	#menghubungkan sinyal changed di data ke dalam function on_inventory_changed
	data.changed.connect( on_inventory_changed )
	pass

#function yang aktif untuk membersihkan elemen visual yang ada di dalam container UI
func clear_inventory() -> void:
	#melakukan perulang dari setiap node anak
	for c in get_children():
		#menghapus node tersebut dari tree
		c.queue_free()

#function yang aktif untuk menampilkan dan membuat slot berdasarkan data terbaru (update)
func update_inventory( i : int = 0 ) -> void:
	#melakukan perulangan untuk setiap data di slots
	for s in data.slots:
		#membuat instance beru dari scene INVENTORY_SLOT bernama new_slot
		var new_slot = INVENTORY_SLOT.instantiate()
		#menmbahkan new_slot sebagai anak dari node ini
		add_child( new_slot )
		#memasukan data slot (s) kedalam new_slot
		new_slot.slot_data = s
		#menghubungkan sinyal focus_entered di new_slot kedalam fucntion item_focused
		new_slot.focus_entered.connect( item_focused )
	#menunggu satu proses frame selesai dari scene tree
	await get_tree().process_frame
	#memberikan focus secara otomatis pada index slot tertentu
	get_child( i ).grab_focus()

#function untuk mendeteksi dan menyimpan index slot yang sedang aktif/difokuskan
func item_focused() -> void:
	#mengecek setiap anak menggunakan perulangan
	for i in get_child_count():
		#jika ditemukan anak pada index i memiliki focus
		if get_child( i ).has_focus():
			#simpan index tersebut ke variabel focus index
			focus_index = i
			#hentikan function
			return
	pass

#function callback yang dipicu setiap kali ada perubahan pada resource InventoryData
func on_inventory_changed() -> void:
	#menyimpa pada index fokus terakhir agar tidak berpindah saat UI refresh
	var i = focus_index
	#memanggil function clear_inventory()
	clear_inventory()
	#memperbarui tampilan dengan data terbaru dan mengembalikan fokus pada posisi semula 
	update_inventory( i )
