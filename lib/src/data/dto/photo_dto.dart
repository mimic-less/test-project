class PhotoDto {
  PhotoDto({required this.id, required this.author, required this.url});

  factory PhotoDto.fromJson(Map<String, dynamic> json) {
    return PhotoDto(
      id: json['id'],
      author: json['author'],
      url: json['download_url'],
    );
  }

  final String id;
  final String author;
  final String url;
}
