import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/gallery_repository.dart';
import '../../domain/models/photo.dart';
import '../dto/photo_dto.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  GalleryRepositoryImpl(this._dio);

  final Dio _dio;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<List<Photo>> fetch(int page, {int limit = 20}) async {
    try {
      final result = await _dio.get(
        'https://picsum.photos/v2/list?page=$page&limit=$limit',
      );
      return await Isolate.run<List<Photo>>(() {
        return (result.data as List)
            .map((e) => PhotoDto.fromJson(e as Map<String, dynamic>))
            .map((e) => Photo(id: e.id, author: e.author, path: e.url))
            .toList();
      });
    } on DioException {
      rethrow;
    }
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
