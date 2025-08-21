import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m_diabetic_care/model/educational_content.dart';
import 'package:m_diabetic_care/services/api_service.dart';

class EdukasiPosterPage extends StatefulWidget {
  const EdukasiPosterPage({super.key});

  @override
  State<EdukasiPosterPage> createState() => _EdukasiPosterPageState();
}

class _EdukasiPosterPageState extends State<EdukasiPosterPage> {
  List<EducationalContent> posters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPosters();
  }

  Future<void> loadPosters() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final result = await ApiService.fetchEducationalPosters(token);
      setState(() {
        posters = result;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Poster Edukasi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : posters.isEmpty
              ? const Center(child: Text('Tidak ada poster ditemukan.'))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  itemCount: posters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemBuilder: (context, index) {
                    final poster = posters[index];
                    final imageUrl =
                        'http://148.230.97.120/diabetic${poster.url}';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PosterDetailPage(poster: poster),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}

class PosterDetailPage extends StatelessWidget {
  final EducationalContent poster;

  const PosterDetailPage({super.key, required this.poster});

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://148.230.97.120/diabetic${poster.url}';

    return Scaffold(
      appBar: AppBar(title: Text(poster.title)),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null)
                  return child; // gambar udah selesai
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(poster.content, style: const TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}
