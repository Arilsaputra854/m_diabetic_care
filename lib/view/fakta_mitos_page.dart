import 'dart:math';
import 'package:flutter/material.dart';

class MitosFaktaPage extends StatefulWidget {
  const MitosFaktaPage({super.key});

  @override
  State<MitosFaktaPage> createState() => _MitosFaktaPageState();
}

class _MitosFaktaPageState extends State<MitosFaktaPage> {
  final List<Map<String, dynamic>> _originalData = [
    {
      'mitos': 'Diabetes bukanlah penyakit yang serius.',
      'fakta':
          'Diabetes dapat menyebabkan komplikasi serius seperti penyakit jantung, gagal ginjal, kebutaan, dan amputasi.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Orang dengan diabetes tidak boleh makan makanan manis atau karbohidrat.',
      'fakta':
          'Penderita diabetes masih bisa menikmati makanan manis dalam jumlah sedang sebagai bagian dari diet seimbang.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Hanya orang yang kelebihan berat badan yang terkena diabetes.',
      'fakta':
          'Orang kurus pun bisa terkena diabetes karena faktor genetik dan gaya hidup tidak sehat.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Insulin menyembuhkan diabetes.',
      'fakta':
          'Insulin hanya mengelola kadar gula, bukan menyembuhkan. Gaya hidup sehat tetap diperlukan.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Diabetes adalah penyakit orang tua.',
      'fakta':
          'Anak dan remaja kini juga rentan terkena diabetes karena obesitas dan pola hidup tidak sehat.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Diabetes hanya terjadi jika ada riwayat keluarga.',
      'fakta':
          'Tanpa riwayat keluarga pun seseorang bisa terkena karena pola hidup buruk.',
      'jawabanBenar': 'Mitos',
    },
    {
      'mitos': 'Penderita diabetes sebaiknya menghindari olahraga.',
      'fakta':
          'Olahraga sangat dianjurkan untuk membantu mengatur gula darah dan meningkatkan kebugaran.',
      'jawabanBenar': 'Mitos',
    },
  ];

  late Map<String, dynamic> _currentQuestion;
  String? _userAnswer;

  @override
  void initState() {
    super.initState();
    _pickRandomQuestion();
  }

  void _pickRandomQuestion() {
    final random = Random();
    setState(() {
      _currentQuestion = _originalData[random.nextInt(_originalData.length)];
      _userAnswer = null;
    });
  }

  void _selectAnswer(String answer) {
    if (_userAnswer == null) {
      setState(() {
        _userAnswer = answer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCorrect = _userAnswer == _currentQuestion['jawabanBenar'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fakta / Mitos'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.question_mark, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      _currentQuestion['mitos'],
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    if (_userAnswer == null)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _selectAnswer("Fakta"),
                              child: const Text("Fakta"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _selectAnswer("Mitos"),
                              child: const Text("Mitos"),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: isCorrect ? Colors.green : Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCorrect ? "Benar!" : "Salah!",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCorrect ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Fakta: ${_currentQuestion['fakta']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _pickRandomQuestion,
                          child: const Text("Pertanyaan Selanjutnya"),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
