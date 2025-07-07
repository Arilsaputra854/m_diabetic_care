import 'package:flutter/material.dart';

class EdukasiBeritaPage extends StatelessWidget {
  const EdukasiBeritaPage({super.key});

  Widget buildCard(String title, List<String> items) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("• $item"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edukasi & Berita DM')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCard('Peningkatan Kasus Diabetes di Indonesia', [
              'Kasus diabetes pada anak di Indonesia meningkat drastis hingga 70 kali lipat pada tahun 2023 dibandingkan dengan tahun 2010, dengan prevalensi 2 per 100.000 jiwa.',
              'Jumlah penderita diabetes melitus di Kota Yogyakarta juga meningkat dalam tiga tahun terakhir, kemungkinan disebabkan oleh pola hidup tidak teratur dan konsumsi gula berlebihan.',
            ]),
            buildCard('Penelitian Terbaru', [
              'Sebuah penelitian di National University Hospital Singapura menemukan bahwa wanita berusia 45-69 tahun dengan kekuatan otot buruk memiliki risiko dua kali lebih besar untuk terkena diabetes.',
              'Ilmuwan dari Aston University menemukan cara lebih akurat untuk memeriksa aliran darah di kaki penderita diabetes tipe 2 menggunakan laser.',
            ]),
            buildCard('Risiko dan Komplikasi', [
              'Penderita diabetes yang mengalami episode gula darah rendah lebih cenderung mengalami penyakit mata diabetes yang memburuk.',
              'Penderita diabetes tipe 2 juga memiliki risiko lebih besar untuk terkena kanker, terutama kanker hati, pankreas, dan endometrium.',
            ]),
            buildCard('Statistik dan Prevalensi', [
              'Indonesia berada di posisi ke-5 dunia dengan jumlah pengidap diabetes sebanyak 19,47 juta, prevalensi diabetes sebesar 10,6 persen.',
              'Jumlah penderita diabetes melitus di Indonesia meningkat dari 10,7 juta pada 2019 menjadi 19,5 juta pada tahun 2021.',
            ]),
            buildCard('Edukasi Perilaku Hidup Sehat (Perkeni 2021)', [
              'a. Mengikuti pola makan sehat.',
              'b. Meningkatkan kegiatan jasmani dan latihan jasmani yang teratur.',
              'c. Menggunakan obat DM dan obat lainya pada keadaan khusus secara aman dan teratur.',
              'd. Melakukan Pemantauan Glukosa Darah Mandiri (PGDM) dan memanfaatkan hasil pemantauan untuk menilai keberhasilan pengobatan.',
              'e. Melakukan perawatan kaki secara berkala.',
              'f. Memiliki kemampuan untuk mengenal dan menghadapi keadaan sakit akut dengan tepat.',
              'g. Mempunyai keterampilan mengatasi masalah yang sederhana, dan mau bergabung dengan kelompok pasien diabetes serta mengajak keluarga untuk mengerti pengelolaan pasien DM.',
              'h. Mampu memanfaatkan fasilitas pelayanan kesehatan yang ada.',
            ]),
          ],
        ),
      ),
    );
  }
}
