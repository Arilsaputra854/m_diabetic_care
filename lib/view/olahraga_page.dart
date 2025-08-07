import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/olahraga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart'; // Ganti path jika perlu

class OlahragaPage extends StatefulWidget {
  const OlahragaPage({super.key});

  @override
  State<OlahragaPage> createState() => _OlahragaPageState();
}

class _OlahragaPageState extends State<OlahragaPage> {
  List<ExerciseReminder> _exerciseList = [];
  Set<String> _completedToday = {};
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
    _loadCompletedToday().then((_) => _fetchExercises());
  }

  Future<void> _loadTokenAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      _token = token;
      await _fetchExercises();
    }
  }

  Future<void> _fetchExercises() async {
    try {
      final data = await ApiService.getExerciseReminders(_token!);
      setState(() {
        _exerciseList =
            data.where((e) {
              final key = "${e.exerciseType}_${e.scheduledTime}";
              return !_completedToday.contains(key);
            }).toList();
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _showAddDialog() async {
    final typeController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Latihan"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Tipe Latihan'),
                  validator:
                      (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      selectedTime = pickedTime;
                      timeController.text = pickedTime.format(context);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Jam (HH:mm)',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      validator:
                          (val) => val!.isEmpty ? 'Wajib pilih jam' : null,
                    ),
                  ),
                ),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Durasi (menit)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Tidak boleh kosong';
                    if (int.tryParse(val) == null) return 'Harus berupa angka';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final formattedTime =
                      selectedTime != null
                          ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                          : timeController.text;

                  final body = {
                    'exercise_type': typeController.text,
                    'scheduled_time': formattedTime,
                    'duration_minutes': int.parse(durationController.text),
                    'notes': '-',
                  };

                  await ApiService.createExerciseReminder(_token!, body);
                  Navigator.pop(context);
                  _fetchExercises();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan"),
        automaticallyImplyLeading: false,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchExercises,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _sectionCard(
                      title: "Aktivitas Mingguan",
                      subtitle: "Tujuan Anda adalah 150 menit per minggu.",
                      progressValue: _exerciseList.fold(
                        0,
                        (sum, e) => sum + e.durationMinutes,
                      ),
                      progressMax: 150,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Aktivitas Hari Ini",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._exerciseList.map((e) {
                      final key = "${e.exerciseType}_${e.scheduledTime}";
                      final text =
                          "${e.durationMinutes} menit ${e.exerciseType} (${e.scheduledTime})";
                      return _activityItem(
                        key,
                        text,
                        reminder: e,
                      );
                    }),

                    _activityItem(
                      "Tambah",
                      "Tambah item baru",
                      isAdd: true,
                      onTap: _showAddDialog,
                    ),

                    const SizedBox(height: 20),
                    _tipsBox(),
                  ],
                ),
              ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String subtitle,
    required int progressValue,
    required int progressMax,
  }) {
    final double progress = progressValue / progressMax;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            "$progressValue / $progressMax menit",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _activityItem(
    String key,
    String text, {
    bool isAdd = false,
    VoidCallback? onTap,
    ExerciseReminder? reminder,
  }) {
    if (isAdd) {
      return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: const [
              SizedBox(width: 8),
              Expanded(child: Text("Tambah")),
              Icon(Icons.add_circle_outline),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _completedToday.contains(key),
            onChanged: (checked) async {
              if (checked == true) {
                setState(() {
                  _completedToday.add(key);
                });
                await _saveCompletedToday();
                Future.delayed(const Duration(milliseconds: 300), () {
                  setState(() {
                    _exerciseList.removeWhere(
                      (e) => "${e.exerciseType}_${e.scheduledTime}" == key,
                    );
                  });
                });
              }
            },
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                _showEditDialog(reminder!);
              } else if (value == 'delete') {
                await ApiService.deleteExerciseReminder(_token!, reminder!.id!);
                _fetchExercises();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(ExerciseReminder reminder) async {
    final typeController = TextEditingController(text: reminder.exerciseType);
    final timeController = TextEditingController(text: reminder.scheduledTime);
    final durationController = TextEditingController(
      text: reminder.durationMinutes.toString(),
    );
    final formKey = GlobalKey<FormState>();
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Edit Latihan"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Tipe Latihan'),
                  validator:
                      (val) => val!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: int.parse(reminder.scheduledTime.split(":")[0]),
                        minute: int.parse(reminder.scheduledTime.split(":")[1]),
                      ),
                    );
                    if (pickedTime != null) {
                      selectedTime = pickedTime;
                      timeController.text = pickedTime.format(context);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Jam (HH:mm)',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      validator:
                          (val) => val!.isEmpty ? 'Wajib pilih jam' : null,
                    ),
                  ),
                ),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Durasi (menit)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Tidak boleh kosong';
                    if (int.tryParse(val) == null) return 'Harus berupa angka';
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final formattedTime =
                      selectedTime != null
                          ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                          : reminder.scheduledTime;

                  final body = {
                    'exercise_type': typeController.text,
                    'scheduled_time': formattedTime,
                    'duration_minutes': int.parse(durationController.text),
                  };

                  await ApiService.updateExerciseReminder(
                    _token!,
                    reminder.id!,
                    body,
                  );
                  Navigator.pop(context);
                  _fetchExercises();
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _tipsBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Selalu periksa kadar gula darah anda sebelum berolahraga. Jika kadarnya di bawah 100 mg/dL, makanlah cemilan kecil.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('completedToday', _completedToday.toList());
  }

  Future<void> _loadCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('completedToday') ?? [];
    setState(() {
      _completedToday = saved.toSet();
    });
  }
}
