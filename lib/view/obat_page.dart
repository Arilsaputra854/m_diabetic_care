import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/obat.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengobatanPage extends StatefulWidget {
  final VoidCallback onTambahObat;
  final VoidCallback onBack;
  final Function(int index) onDelete;
  final VoidCallback onDataChanged;

  const PengobatanPage({
    super.key,
    required this.onTambahObat,
    required this.onBack,
    required this.onDelete,
    required this.onDataChanged,
  });

  @override
  State<PengobatanPage> createState() => _PengobatanPageState();
}

class _PengobatanPageState extends State<PengobatanPage> {
  List<Obat> obatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadObat();
  }

  Future<void> _loadObat() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final data = await ApiService.getMedicationReminders(token);
    setState(() {
      obatList = data;
      isLoading = false;
    });
  }

  void _handleDelete(int index) {
    setState(() {
      obatList.removeAt(index);
    });
    widget.onDelete(index);    
    widget.onDataChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              ),
              const Text(
                'Pengobatan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text("Anda sedang dalam", style: TextStyle(fontSize: 14)),
                SizedBox(height: 4),
                Text(
                  "12 Hari Beruntun!🔥",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Teruskan!", style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Jadwal Hari Ini",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : obatList.isEmpty
                    ? const Center(
                      child: Text("Belum ada jadwal obat hari ini."),
                    )
                    : ListView.separated(
                      itemCount: obatList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final obat = obatList[index];
                        return GestureDetector(
                          onLongPress: () {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Opsi Obat"),
      content: Text("Pilih tindakan untuk '${obat.nama}'"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _showEditDialog(obat, index);
          },
          child: const Text("Edit"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ApiService.deleteMedicationReminder(obat.id); // Hapus dari server
            _handleDelete(index); // Hapus dari UI
          },
          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
},

                          child: Container(
                            decoration: BoxDecoration(
                              color: obat.warna,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: ListTile(
                              leading: Icon(obat.icon, color: Colors.grey[700]),
                              title: Text(
                                obat.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Jam: ${obat.jadwal}"),
                                  Text("Dosis: ${obat.dosage}"),
                                  Text("Tipe: ${obat.tipe}"),
                                  Text(obat.keterangan),
                                ],
                              ),

                              trailing:
                                  obat.status.isNotEmpty
                                      ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: obat.labelColor,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          obat.status,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: obat.textColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                      : null,
                            ),
                          ),
                        );
                      },
                    ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onTambahObat,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Obat"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[300],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Obat obat, int index) {
  final namaController = TextEditingController(text: obat.nama);
  final dosisController = TextEditingController(text: obat.dosage);
  final keteranganController = TextEditingController(text: obat.keterangan);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Edit Obat"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: namaController,
            decoration: const InputDecoration(labelText: "Nama Obat"),
          ),
          TextField(
            controller: dosisController,
            decoration: const InputDecoration(labelText: "Dosis"),
          ),
          TextField(
            controller: keteranganController,
            decoration: const InputDecoration(labelText: "Keterangan"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);

            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('access_token') ?? '';

            final updatedObat = obat.copyWith(
              nama: namaController.text,
              dosage: dosisController.text,
              keterangan: keteranganController.text,
            );

            await ApiService.updateMedicationReminder(token, updatedObat);
            setState(() {
              obatList[index] = updatedObat;
            });
  widget.onDataChanged();
          },
          child: const Text("Simpan"),
        ),
      ],
    ),
  );
}

}
