part of 'gallery_notifier.dart';

class GalleryState {
  GalleryState({
    required this.photos,
    required this.isLoading,
    required this.hasMore,
    required this.page,
  });

  GalleryState.initial()
    : photos = const [],
      isLoading = false,
      hasMore = true,
      page = 1;

  final List<Photo> photos;
  final bool isLoading;
  final bool hasMore;
  final int page;

  GalleryState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return GalleryState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
