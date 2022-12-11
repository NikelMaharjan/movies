


class Video {

  final String key;
  final String name;
  final String id;


  Video({required this.key, required this.name, required this.id});

  factory Video.fromJson(Map<String, dynamic>json){
    return Video(
        key: json['key'],
        name: json['name'],
        id: json['id']
    );
  }

}
