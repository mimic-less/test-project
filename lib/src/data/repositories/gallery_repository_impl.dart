import 'dart:isolate';

import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/gallery_repository.dart';
import '../../domain/models/photo.dart';
import '../dto/photo_dto.dart';

import '../api/api_client.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  GalleryRepositoryImpl(this._api);

  final ApiClient _api;
  final ImagePicker _imagePicker = ImagePicker();

  static const _galleryUriPath = 'https://picsum.photos/v2/list';

  @override
  Future<List<Photo>> fetch(int page, {int limit = 20}) async {
    final res = await _api.get(
      fullPath: '$_galleryUriPath?page=$page&limit=$limit',
    );

    final list = await Isolate.run<List<Photo>>(() {
      return (res as List)
          .map((e) => PhotoDto.fromJson(e as Map<String, dynamic>))
          .map((e) => Photo(id: e.id, author: e.author, path: e.url))
          .toList();
    });

    return list;
  }

  @override
  Future<Photo?> pickLocalImage() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (file == null) return null;

    return Photo(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      path: file.path,
      isLocal: true,
    );
  }
}
