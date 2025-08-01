// models/educational_content.dart
class EducationalContent {
  final int id;
  final String title;
  final String type;
  final String content;
  final String url;
  final String category;

  EducationalContent({
    required this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.url,
    required this.category,
  });

  factory EducationalContent.fromJson(Map<String, dynamic> json) {
    return EducationalContent(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      content: json['content'],
      url: json['url'],
      category: json['category'],
    );
  }
}
