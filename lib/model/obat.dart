import 'package:flutter/material.dart';

class Obat {
  final int? id;
  final String nama;
  final String jadwal;       // waktu minum
  final String keterangan;   // notes
  final String tipe;         // oral/injeksi
  final String dosage;       // Dosis
  final String status;
  final Color warna;
  final IconData icon;
  final Color? labelColor;
  final Color? textColor;

  Obat({
    this.id,
    required this.nama,
    required this.jadwal,
    required this.keterangan,
    required this.tipe,
    required this.dosage,
    this.status = '',
    this.warna = Colors.white,
    this.icon = Icons.medical_services_outlined,
    this.labelColor,
    this.textColor,
  });

  factory Obat.fromJson(Map<String, dynamic> json) {
    return Obat(
      id: json['id'],
      nama: json['medication_name'],
      jadwal: json['time'],
      keterangan: json['notes'] ?? '-',
      tipe: json['type'] ?? 'oral',
      dosage: json['dosage'] ?? '-',
      status: '',
      warna: Colors.white,
      icon: Icons.medical_services_outlined,
      labelColor: Colors.green[100],
      textColor: Colors.green[900],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medication_name': nama,
      'time': jadwal,
      'notes': keterangan,
      'type': tipe,
      'dosage': dosage,
    };
  }

  Obat copyWith({
  String? nama,
  String? dosage,
  String? jadwal,
  String? tipe,
  String? keterangan,
}) {
  return Obat(
    id: id,
    nama: nama ?? this.nama,
    dosage: dosage ?? this.dosage,
    jadwal: jadwal ?? this.jadwal,
    tipe: tipe ?? this.tipe,
    keterangan: keterangan ?? this.keterangan,
    // Tambahkan field lain sesuai kebutuhan
  );
}

}
