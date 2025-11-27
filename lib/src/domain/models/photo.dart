class Photo {
  Photo({
    required this.id,
    required this.path,
    this.isLocal = false,
    this.author = '',
  });

  final String id;
  final String author;
  final String path;
  final bool isLocal;
}
