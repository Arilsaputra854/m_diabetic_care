import 'package:flutter/material.dart';
import 'package:m_diabetic_care/model/educational_content.dart';
import 'package:m_diabetic_care/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EdukasiVideoPage extends StatefulWidget {
  const EdukasiVideoPage({super.key});

  @override
  State<EdukasiVideoPage> createState() => _EdukasiVideoPageState();
}

class _EdukasiVideoPageState extends State<EdukasiVideoPage> {
  List<EducationalContent> videos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVideos();
  }

  Future<void> loadVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final result = await ApiService.fetchEducationalVideos(token);
      setState(() {
        videos = result;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Video Edukasi")),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : videos.isEmpty
              ? const Center(child: Text('Tidak ada video ditemukan.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];

                  final videoId = YoutubePlayer.convertUrlToId(video.url) ?? '';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId: videoId,
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                mute: false,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.teal,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.teal,
                              handleColor: Colors.tealAccent,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            video.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            video.content,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
