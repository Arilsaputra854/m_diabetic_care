import 'package:flutter/material.dart';

class ReminderObatPage extends StatefulWidget {
  const ReminderObatPage({super.key});

  @override
  State<ReminderObatPage> createState() => _ReminderObatPageState();
}

class _ReminderObatPageState extends State<ReminderObatPage> {
  String selectedTherapy = 'Obat';
  final List<Map<String, String>> reminders = [];

  final TextEditingController namaObatController = TextEditingController();
  TimeOfDay? selectedTime;

  void _addReminder() {
    if (namaObatController.text.isNotEmpty && selectedTime != null) {
      setState(() {
        reminders.add({
          'nama': namaObatController.text,
          'waktu': selectedTime!.format(context),
        });
        namaObatController.clear();
        selectedTime = null;
      });
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Obat'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Pilihan terapi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Obat"),
                  selected: selectedTherapy == 'Obat',
                  onSelected: (_) => setState(() => selectedTherapy = 'Obat'),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text("Insulin"),
                  selected: selectedTherapy == 'Insulin',
                  onSelected: (_) => setState(() => selectedTherapy = 'Insulin'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Input Nama Obat/Insulin
            TextField(
              controller: namaObatController,
              decoration: InputDecoration(
                labelText: selectedTherapy == 'Obat' ? 'Nama Obat' : 'Jenis Insulin',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Picker waktu minum
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedTime == null
                          ? 'Pilih Waktu'
                          : selectedTime!.format(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol Tambah
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addReminder,
                child: const Text('Tambah Pengingat'),
              ),
            ),
            const SizedBox(height: 24),

            // List pengingat yang sudah diatur
            const Divider(),
            const Text(
              'Jadwal Pengingat:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: reminders.isEmpty
                  ? const Text('Belum ada pengingat ditambahkan.')
                  : ListView.builder(
                      itemCount: reminders.length,
                      itemBuilder: (context, index) {
                        final item = reminders[index];
                        return ListTile(
                          leading: const Icon(Icons.medication),
                          title: Text(item['nama']!),
                          subtitle: Text('Waktu: ${item['waktu']}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
