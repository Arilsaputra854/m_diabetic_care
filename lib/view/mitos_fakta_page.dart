import 'package:flutter/material.dart';

class MitosFaktaPage extends StatelessWidget {
  const MitosFaktaPage({super.key});

  final List<Map<String, String>> dataMitosFakta = const [
    {
      'mitos': 'Diabetes bukanlah penyakit yang serius.',
      'fakta':
          'Diabetes dapat menyebabkan komplikasi serius seperti penyakit jantung, gagal ginjal, kebutaan, dan amputasi. WHO menyebut diabetes sebagai penyebab utama morbiditas dan mortalitas global.',
    },
    {
      'mitos': 'Orang dengan diabetes tidak boleh makan makanan manis atau karbohidrat.',
      'fakta':
          'Penderita diabetes masih bisa menikmati makanan manis dalam jumlah sedang sebagai bagian dari diet seimbang. Asupan karbohidrat harus dipantau dengan kontrol glikemik yang tepat.',
    },
    {
      'mitos': 'Hanya orang yang kelebihan berat badan yang terkena diabetes.',
      'fakta':
          'Individu dengan berat badan normal juga dapat terkena diabetes karena faktor genetik dan gaya hidup tidak aktif.',
    },
    {
      'mitos': 'Insulin menyembuhkan diabetes.',
      'fakta':
          'Insulin hanya membantu mengelola kadar gula darah, bukan menyembuhkan diabetes. Pengelolaan juga melibatkan gaya hidup sehat dan kepatuhan terhadap pengobatan.',
    },
    {
      'mitos': 'Diabetes adalah penyakit orang tua.',
      'fakta':
          'Diabetes tipe 2 kini banyak didiagnosis pada anak-anak dan remaja akibat meningkatnya obesitas di usia muda.',
    },
    {
      'mitos': 'Diabetes hanya terjadi jika ada riwayat keluarga.',
      'fakta':
          'Gaya hidup tidak sehat juga menjadi faktor besar, meskipun tidak ada riwayat keluarga.',
    },
    {
      'mitos': 'Penderita diabetes sebaiknya menghindari olahraga.',
      'fakta':
          'Olahraga justru membantu menurunkan gula darah, mengontrol berat badan, dan mengurangi risiko penyakit jantung.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mitos vs Fakta Diabetes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataMitosFakta.length,
        itemBuilder: (context, index) {
          final item = dataMitosFakta[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(
                'Mitos ${index + 1}: ${item['mitos']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Fakta: ${item['fakta']}',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
