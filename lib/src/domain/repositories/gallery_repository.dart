import '../models/photo.dart';

abstract class GalleryRepository {
  Future<List<Photo>> fetch(int page, {int limit = 20});
  Future<Photo?> pickLocalImage();
}
