import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TextEditingController _dosisController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedKeterangan;
  String? _selectedTipeObat;
  final List<String> _tipeObat = ['oral', 'injeksi'];

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

  void _simpanObat() async {
  if (_namaController.text.isNotEmpty &&
      _dosisController.text.isNotEmpty &&
      _selectedTime != null &&
      _selectedKeterangan != null &&
      _selectedTipeObat != null) {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    final timeFormatted =
        "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

    final success = await ApiService.submitMedicationReminder(
      token: token,
      medicationName: _namaController.text,
      dosage: _dosisController.text,
      time: timeFormatted,
      type: _selectedTipeObat!,
      notes: _selectedKeterangan!,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Obat berhasil disimpan")),
      );
      widget.onBack();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data obat")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lengkapi semua field terlebih dahulu.")),
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
            ),
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
                TextField(
                  controller: _dosisController,
                  decoration: const InputDecoration(
                    labelText: "Dosis",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedTipeObat,
                  items:
                      _tipeObat.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            item[0].toUpperCase() + item.substring(1),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipeObat = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Tipe Obat",
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
                  items:
                      _keteranganWaktu
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ),
                          )
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
