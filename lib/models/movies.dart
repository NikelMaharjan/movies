class Movie {
  final int id;
  final String title;
  final String overview;
  final String vote_average; //vote_average in double..since it will be difficult to display double. we convert into string directly here
  final String poster_path;
  final String backdrop_path;
  final String release_date;
  final String popularity; //popularity is also in double..since it will be difficult to display double. we convert into string directly here

  Movie(
      {required this.id,
      required this.title,
      required this.backdrop_path,
      required this.release_date,
      required this.overview,
      required this.vote_average,
      required this.popularity,
      required this.poster_path});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      backdrop_path: json['backdrop_path'] ?? '',
      overview: json['overview'] ?? '',
      poster_path: json['poster_path'] ?? '',
      vote_average: '${json['vote_average']}', // '' is String
      release_date: json['release_date'],
      popularity: '${json['popularity']}',
    );
  }
}
