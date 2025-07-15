import 'package:flutter/material.dart';

class TambahObatPage extends StatefulWidget {
  final Function(String nama, String waktu) onSimpan;
  final VoidCallback onBack;

  const TambahObatPage({
    super.key,
    required this.onSimpan,
    required this.onBack,
  });

  @override
  State<TambahObatPage> createState() => _TambahObatPageState();
}

class _TambahObatPageState extends State<TambahObatPage> {
  final TextEditingController _namaController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedKeterangan;

  final List<String> _keteranganWaktu = [
    "Sebelum Makan",
    "Sesudah Makan",
    "Sebelum Tidur",
  ];

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _simpanObat() {
    if (_namaController.text.isNotEmpty &&
        _selectedTime != null &&
        _selectedKeterangan != null) {
      final jam = _selectedTime!.format(context);
      final waktu = "$jam - $_selectedKeterangan";

      widget.onSimpan(_namaController.text, waktu); // kirim data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi semua field terlebih dahulu."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom header with back
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onBack,
            ),
            const Text(
              "Tambah Obat",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Obat",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                InkWell(
                  onTap: _pickTime,
                  borderRadius: BorderRadius.circular(8),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: "Jam Minum",
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : "Pilih Jam",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _selectedKeterangan,
                  items: _keteranganWaktu
                      .map((item) => DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedKeterangan = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Keterangan Waktu",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _simpanObat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Simpan"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
