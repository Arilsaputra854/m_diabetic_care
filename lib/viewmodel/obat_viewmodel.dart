import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/obat.dart';
import '../services/api_service.dart';

class ObatViewModel extends ChangeNotifier {
  List<Obat> _obatList = [];
  bool _isLoading = false;

  List<Obat> get obatList => _obatList;
  bool get isLoading => _isLoading;

  /// Load semua obat dari API
  Future<void> fetchObat() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final data = await ApiService.getMedicationReminders(token);
      _obatList = data;
    } catch (e) {
      debugPrint("Error fetch obat: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Obat?> addObat(Obat newObat) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      final response = await ApiService.submitMedicationReminder(
        token: token,
        medicationName: newObat.nama,
        dosage: newObat.dosage,
        time: newObat.jadwal,
        type: newObat.tipe,
        notes: newObat.keterangan,
      );

      if (response != null) {
        await fetchObat(); // refresh list hanya kalau berhasil simpan
        notifyListeners(); // trigger UI
        return response;
      } else {
        debugPrint("❌ Gagal menambahkan obat (API return != 201)");
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error add obat: $e");

      return null;
    }
  }

  /// Update obat
 Future<Obat?> updateObat(Obat updatedObat) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token') ?? '';

  try {
    final newObat = await ApiService.updateMedicationReminder(token, updatedObat);
    
    // update list di local VM
    final index = _obatList.indexWhere((o) => o.id == updatedObat.id);
    if (index != -1) {
      _obatList[index] = newObat;
      notifyListeners();
    }

    return newObat;
  } catch (e) {
    debugPrint("Error update obat: $e");
    return null;
  }
}


  /// Hapus obat
  Future<void> deleteObat(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    try {
      await ApiService.deleteMedicationReminder(id);
      _obatList.removeWhere((o) => o.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error delete obat: $e");
    }
  }
}
