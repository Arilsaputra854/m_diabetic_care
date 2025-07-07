import 'package:flutter/material.dart';

class ManajemenLukaPage extends StatelessWidget {
  const ManajemenLukaPage({super.key});

  Widget buildCard(String title, List<String> content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...content.map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(text),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Luka DM')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tujuan: Manajemen perawatan luka diperlukan untuk meningkatkan penyembuhan, mencegah kerusakan kulit lebih lanjut, mengurangi risiko infeksi, dan meningkatkan kenyamanan pasien. Berbagai jenis luka yang dikaitkan dengan tahap penyembuhan luka memerlukan manajemen luka yang tepat (Holloway & Harding, 2024).',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            buildCard('1. Persiapan Merawat Luka', [
              'Cuci tangan adalah proses mekanik melapaskan kotoran dan debris dari kulit tangan dengan menggunakan sabun dan air.',
              'Cuci tangan harus dilakukan dengan baik dan benar sebelum dan sesudah melakukan tindakan keperawatan walaupun memakai sarung tangan atau alat pelindung lain.',
              'Hal ini dilakukan untuk menghilangkan atau mengurangi mikroorganisme yang ada di tangan sehingga penyebaran penyakit dapat dikurangi dan lingkungan terjaga dari infeksi (Toney-Butler et al., 2023).',
            ]),
            buildCard('2. Cara Perawatan Membersihkan Luka', [
              'Perawatan Luka Diabetik di rumah merupakan tindakan aseptik membersihkan dan mencuci luka dan diakhiri dengan memilih balutan luka yang tepat.',
              'Debridement atau mengangkat jaringan mati juga sangat penting dilakukan agar luka menjadi baik atau sehat.',
              'Debridemen memberikan manfaat, diantaranya menghilangkan jaringan yang sudah tidak tervaskularisasi, bakteri, dan juga eksudat sehingga akan menciptakan kondisi luka yang dapat menstimulasi munculnya jaringan sehat (Dayya et al., 2022).',
              'Perawatan luka yang diberikan pada pasien harus dapat meningkatkan proses penyembuhan luka. Perawatan yang diberikan bersifat memberikan kehangatan dan lingkungan yang moist pada luka (Nuutila & Eriksson, 2021).',
            ]),
            buildCard('3. Pembalutan Luka', [
              'Tujuan: Mengabsorsi eksudat dan melindungi luka dari kontaminasi eksogen.',
              'Penggunaan balutan juga harus disesuaikan dengan kondisi luka. Terdapat 3 jenis balutan luka sesuai dengan kondisi luka yaitu balutan kering, balutan basah kering, dan balutan modern (Shi et al., 2020b).',
              '',
              'a. Balutan luka metode konvensional:',
              'Metode yang digunakan adalah perawatan metode konvensional (90%).',
              'Teknik yang digunakan masih alami dan tradisional, belum dikembangkan secara modern.',
              'Balutan konvensional bertujuan untuk melindungi luka dari infeksi.',
              'Namun, saat diganti, kasa akan menempel pada luka dan bisa merusak jaringan baru dan menimbulkan rasa sakit (Stellar & Mattei, 2023).',
              '',
              'b. Balutan luka metode modern:',
              'Mengedepankan prinsip moisturbalance.',
              'Menggunakan bahan seperti hydrogel untuk menjaga kelembapan luka.',
              'Hydrogel melunakkan serta menghancurkan jaringan nekrotik tanpa merusak jaringan sehat, dan terbuang bersama pembalut (Manna et al., 2023).',
              'Balutan bisa diaplikasikan selama 3–5 hari sehingga tidak sering diganti dan mengurangi nyeri.',
            ]),
            buildCard('4. Perawatan Luka Diabetik di Rumah', [
              'Perawatan ulkus diabetes terdiri dari 3 komponen utama: debridement, offloading, dan penanganan infeksi.',
              'Penggunaan balutan yang efektif dan tepat membantu penanganan ulkus diabetes yang optimal.',
              'Keadaan sekitar luka harus dijaga kebersihan dan kelembapannya (Everett & Mathioudakis, 2018).',
            ]),
          ],
        ),
      ),
    );
  }
}
