import 'package:flutter/material.dart';
import 'package:m_diabetic_care/viewmodel/bmi_viewmodel.dart';
import 'package:provider/provider.dart';

class UpdateBmiPage extends StatelessWidget {
  const UpdateBmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BmiViewModel>(context);

    final heightController = TextEditingController();
    final weightController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Perbarui BMI')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField(label: 'Tinggi', controller: heightController, suffix: 'cm'),
            const SizedBox(height: 16),
            _buildField(label: 'Berat', controller: weightController, suffix: 'kg'),
            const SizedBox(height: 24),
            if (viewModel.bmi != null)
              Text('BMI: ${viewModel.bmi!.toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : () async {
                        final height = double.tryParse(heightController.text) ?? 0;
                        final weight = double.tryParse(weightController.text) ?? 0;

                        final success = await viewModel.updateBmi(height, weight);

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('BMI berhasil diperbarui')),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Gagal memperbarui BMI')),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5C63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Simpan BMI'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
