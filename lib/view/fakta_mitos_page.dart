import 'package:flutter/material.dart';
import 'package:m_diabetic_care/viewmodel/myths_facts_view_model.dart';
import 'package:provider/provider.dart';
class MitosFaktaPage extends StatefulWidget {
  const MitosFaktaPage({super.key});

  @override
  State<MitosFaktaPage> createState() => _MitosFaktaPageState();
}

class _MitosFaktaPageState extends State<MitosFaktaPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MythsFactsViewModel>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MythsFactsViewModel>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (vm.isError || vm.currentQuestion == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Fakta / Mitos')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat data.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: vm.fetchData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final q = vm.currentQuestion!;
        final isAnswered = vm.userAnswer != null;

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.question_mark, size: 40),
                        const SizedBox(height: 12),
                        Text(
                          q['myth'],
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        if (!isAnswered)
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => vm.selectAnswer("Fakta"),
                                  child: const Text("Fakta"),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => vm.selectAnswer("Mitos"),
                                  child: const Text("Mitos"),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          Icon(
                            vm.isCorrect ? Icons.check_circle : Icons.cancel,
                            color: vm.isCorrect ? Colors.green : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            vm.isCorrect ? "Benar!" : "Salah!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: vm.isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Fakta: ${q['fact']}",
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
                              onPressed: vm.nextQuestion,
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
      },
    );
  }
}
