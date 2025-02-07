// models/lens_record.dart
class LensRecord {
  final int? id;
  final String title;
  final String imageUrl;
  final int percentage;
  final String hours;
  final DateTime lastUpdated;
  final String? comments;

  LensRecord({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.percentage,
    required this.hours,
    required this.lastUpdated,
    this.comments,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'percentage': percentage,
      'hours': hours,
      'lastUpdated': lastUpdated.toIso8601String(),
      'comments': comments,
    };
  }

  factory LensRecord.fromMap(Map<String, dynamic> map) {
    return LensRecord(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      percentage: map['percentage'],
      hours: map['hours'],
      lastUpdated: DateTime.parse(map['lastUpdated']),
      comments: map['comments'],
    );
  }
}
