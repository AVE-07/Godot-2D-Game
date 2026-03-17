#memberi nama class InventoryData yang mewarisi Resource
class_name InventoryData extends Resource

#membuat export di inspector yang menampung data array dari SlotData
@export var slots : Array[ SlotData ]

#function yang aktif untuk inisialisasi
func _init() -> void:
	#menjalankan function connect_slots()
	connect_slots()
	pass

#function untuk menambahkan item beserta jumlahnya dengan parameter item type ItemData dan count type int
func add_item( item : ItemData, count : int = 1 ) -> bool:
	#pengulangan terhadap s di slots
	for s in slots:
		#menguji apakah s tidak kosong, jika s
		if s:
			#jika item sama dengan item_data yang ada di s
			if s.item_data == item:
				#jumlah count akan ditambahkan kedalam quantity di s
				s.quantity += count
				#menghentikan function dengan memberi nilai true
				return true
	
	#untuk mencari index kosong jika stack (s) tidak ada
	#pengulangan i di ukuran slots
	for i in slots.size():
		#jika menemukan index kosong di slots
		if slots [ i ] == null:
			#membuat instance baru dari SlotData
			var new = SlotData.new()
			#mengisi data item kedalam item_data di new
			new.item_data = item
			#mengisi data count kedalam quantity di new
			new.quantity = count
			#memasukan kedua data sebelumnya kedalam index kosong tadi
			slots[ i ] = new
			#menghubungkan sinyal changed di new dan jalankan function slot_changed
			new.changed.connect( slot_changed )
			#menghentikan function dengan memberi nilai true
			return true
	
	#jika inventory full dan tidak ada index kosong print inventory full!
	print( "inventory full!" )
	#menghentikan function dengan memberi nilai false
	return false

#function yang aktif untuk menghubungkan sinyal semua slot yang sudah terisi
func connect_slots() -> void:
	#melakukan perulangan untuk setiap s yang ada di slots
	for s in slots:
		#jika terdapat s (bukan null)
		if s:
			#sambungkan sinyal changed di s dan jalankan function slot_changed
			s.changed.connect( slot_changed )

#function untuk callback setiap ada perubahan pada data di dalam slot
func slot_changed() -> void:
	#mengecek apabila ada item yang quantitynya habis, jika s di slots
	for s in slots:
		#jika terdapat s
		if s:
			#jika quantity item s lebih kecil dari 1 (habis)
			if s.quantity < 1:
				#memutuskan signal changed di s untuk tidak menjalankan function slot_changed
				s.changed.disconnect( slot_changed )
				#membuat variabel index untuk mencari s didalam slots
				var index = slots.find( s )
				#ubah nilai slots s tadi menjadi null
				slots[ index ] = null
				emit_changed()
	pass


## gather inventory into an array
func get_save_data() -> Array:
	var item_save : Array = []
	for i in slots.size():
		item_save.append( item_to_save( slots[i] ) )
	return item_save

## convert each inventory item into a dictionary
func item_to_save( slot : SlotData ) -> Dictionary:
	var result = { item = "", quantity = 0 }
	if slot != null:
		result.quantity = slot.quantity
		if slot.item_data != null:
			result.item = slot.item_data.resource_path
	return result


func parse_save_data( save_data : Array ) -> void:
	var array_size = slots.size()
	slots.clear()
	slots.resize( array_size )
	for i in save_data.size():
		slots[ i ] = item_from_save( save_data[ i ] )
	connect_slots()


func item_from_save( save_object : Dictionary ) -> SlotData:
	if save_object.item == "":
		return null
	var new_slot : SlotData = SlotData.new()
	new_slot.item_data = load( save_object.item )
	new_slot.quantity = int( save_object.quantity )
	return new_slot
