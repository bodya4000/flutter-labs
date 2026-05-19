final class Movie {
  const Movie({required this.id, required this.title, required this.year});

  final int id;
  final String title;
  final int year;

  Map<String, Object?> toJson() => {'id': id, 'title': title, 'year': year};

  factory Movie.fromJson(Map<String, Object?> json) {
    return Movie(
      id: (json['id'] as num).toInt(),
      title: json['title']! as String,
      year: (json['year'] as num).toInt(),
    );
  }
}
