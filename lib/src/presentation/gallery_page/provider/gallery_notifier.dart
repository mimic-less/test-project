import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/photo.dart';
import '../../../domain/repositories/gallery_repository.dart';
import '../../../utils/extensions/dio_exception_extension.dart';

part 'gallery_state.dart';

class GalleryNotifier extends ChangeNotifier {
  GalleryNotifier(this._galleryRepository) {
    loadNext();
  }

  final GalleryRepository _galleryRepository;
  GalleryState state = GalleryState.initial();

  Future<void> loadNext({bool retry = false}) async {
    if (state.isLoading || !state.hasMore) return;
    if (state.error.isNotEmpty && !retry) return;

    state = state.copyWith(isLoading: true, error: '');
    notifyListeners();

    try {
      final data = await _galleryRepository.fetch(state.page);

      state = state.copyWith(
        photos: [...state.photos, ...data],
        isLoading: false,
        hasMore: data.isNotEmpty,
        page: state.page + 1,
      );

      notifyListeners();
    } on DioException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.dioExceptionMessage,
      );
      notifyListeners();
    }
  }

  Future<void> pickAndInsertLocalImage() async {
    if (state.isLoading) return;
    final photo = await _galleryRepository.pickLocalImage();
    if (photo == null) return;

    final updated = [photo, ...state.photos];
    state = state.copyWith(photos: updated);

    notifyListeners();
  }
}
