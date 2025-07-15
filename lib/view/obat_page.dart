import 'package:flutter/material.dart';

class PengobatanPage extends StatelessWidget {
  final List<Map<String, dynamic>> obatList;
  final VoidCallback onTambahObat;
  final VoidCallback onBack;
  final Function(int index) onDelete;

  const PengobatanPage({
    super.key,
    required this.obatList,
    required this.onTambahObat,
    required this.onBack,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Back button
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack),
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
            child: ListView.separated(
              itemCount: obatList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final obat = obatList[index];
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("Hapus Obat"),
                            content: Text(
                              "Yakin ingin menghapus '${obat['nama']}' dari daftar?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onDelete(
                                    index,
                                  ); // ← panggil callback ke HomePage
                                },
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: obat['warna'],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ListTile(
                      leading: Icon(obat['icon'], color: Colors.grey[700]),
                      title: Text(
                        obat['nama'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(obat['waktu']),
                      trailing:
                          obat['status'] != ''
                              ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: obat['labelColor'],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  obat['status'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: obat['textColor'],
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
              onPressed: onTambahObat,
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
}
