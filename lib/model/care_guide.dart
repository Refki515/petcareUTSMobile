class CareGuide {
  const CareGuide({
    required this.id,
    required this.petType,
    required this.category,
    required this.title,
    required this.summary,
    required this.imagePath,
    required this.materials,
    required this.steps,
    required this.note,
    this.readingMinutes = 4,
  });

  final String id;
  final String petType;
  final String category;
  final String title;
  final String summary;
  final String imagePath;
  final List<String> materials;
  final List<String> steps;
  final String note;
  final int readingMinutes;

  factory CareGuide.fromJson(Map<String, dynamic> json) => CareGuide(
    id: json['id'] as String,
    petType: json['petType'] as String,
    category: json['category'] as String,
    title: json['title'] as String,
    summary: json['summary'] as String,
    imagePath: json['imagePath'] as String,
    materials: List<String>.unmodifiable(json['materials'] as List),
    steps: List<String>.unmodifiable(json['steps'] as List),
    note: json['note'] as String,
    readingMinutes: (json['readingMinutes'] as num?)?.toInt() ?? 4,
  );
}
