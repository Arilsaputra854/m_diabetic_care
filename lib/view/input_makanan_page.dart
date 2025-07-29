import 'package:flutter/material.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class InputMakananPage extends StatefulWidget {
  const InputMakananPage({super.key});

  @override
  State<InputMakananPage> createState() => _InputMakananPageState();
}

class _InputMakananPageState extends State<InputMakananPage> {
  final List<String> sesiMakan = ['Pagi', 'Siang', 'Malam', 'Snack'];
  String selectedSesi = 'Pagi';

  List<Map<String, dynamic>> makananTersedia = [];

  final List<Map<String, dynamic>> makananDipilih = [];

  bool showManualInput = false;

  final namaMakananController = TextEditingController();
  final kaloriController = TextEditingController();
  final karboController = TextEditingController();
  final gulaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoodFromApi();
  }

  void _loadFoodFromApi() async {
    try {
      final data = await ApiService.fetchFoodList();
      setState(() {
        makananTersedia
          ..clear()
          ..addAll(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data makanan: $e')),
      );
    }
  }

  void tambahMakanan(Map<String, dynamic> makanan) {
    setState(() {
      makananDipilih.add(makanan);
    });
  }

  int get totalKalori {
    return makananDipilih.fold(0, (sum, item) => sum + item['kalori'] as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Makanan'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilih sesi makan
            DropdownButtonFormField<String>(
              value: selectedSesi,
              items:
                  sesiMakan
                      .map(
                        (e) =>
                            DropdownMenuItem(value: e, child: Text("Makan $e")),
                      )
                      .toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedSesi = val);
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Sesi Makan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // List makanan tersedia
            const Text("Pilih Makanan dari Daftar:"),
            Wrap(
              spacing: 8,
              children:
                  makananTersedia.map((makanan) {
                    return ActionChip(
                      label: Text(makanan['nama']),
                      onPressed: () => tambahMakanan(makanan),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            // Tombol input manual
            OutlinedButton.icon(
              onPressed: () {
                setState(() => showManualInput = !showManualInput);
              },
              icon: const Icon(Icons.add),
              label: const Text('Input Manual (Create New Food)'),
            ),

            if (showManualInput) ...[
              const SizedBox(height: 16),
              TextField(
                controller: namaMakananController,
                decoration: const InputDecoration(
                  labelText: 'Nama Makanan',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: kaloriController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Kalori (kkal)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: karboController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Karbohidrat (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: gulaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Gula (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  if (namaMakananController.text.isNotEmpty &&
                      kaloriController.text.isNotEmpty &&
                      karboController.text.isNotEmpty &&
                      gulaController.text.isNotEmpty) {
                    final success = await ApiService.createFood(
                      name: namaMakananController.text,
                      calories: int.parse(kaloriController.text),
                      carbs: int.parse(karboController.text),
                      sugar: int.parse(gulaController.text),
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Makanan berhasil ditambahkan ke database',
                          ),
                        ),
                      );
                      _loadFoodFromApi(); // Refresh list makanan
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menambahkan makanan'),
                        ),
                      );
                    }

                    namaMakananController.clear();
                    kaloriController.clear();
                    karboController.clear();
                    gulaController.clear();
                    setState(() => showManualInput = false);
                  }
                },
                child: const Text('Tambahkan Makanan Manual'),
              ),

              const SizedBox(height: 16),
            ],

            const Divider(),
            const Text(
              'Daftar Makanan yang Dipilih:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (makananDipilih.isEmpty)
              const Text('Belum ada makanan dipilih.')
            else
              Column(
                children:
                    makananDipilih.map((m) {
                      return ListTile(
                        title: Text(m['nama']),
                        subtitle: Text(
                          'Kalori: ${m['kalori']} kkal, Karbo: ${m['karbo']} g, Gula: ${m['gula']} g',
                        ),
                      );
                    }).toList(),
              ),

            const SizedBox(height: 16),
            Text(
              'Total Kalori Sesi Makan Ini: $totalKalori kkal',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
