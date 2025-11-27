import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/photo.dart';

class GridViewPhoto extends StatelessWidget {
  const GridViewPhoto({
    required this.onTap,
    required this.photo,
    required this.cachePx,
    super.key,
  });

  final void Function(Photo) onTap;
  final Photo photo;
  final int cachePx;

  @override
  Widget build(BuildContext context) {
    if (photo.isLocal) {
      return GestureDetector(
        onTap: () => onTap(photo),
        child: Image.file(
          File(photo.path),
          fit: BoxFit.cover,
          cacheWidth: cachePx,
          cacheHeight: cachePx,
        ),
      );
    }
    return GestureDetector(
      onTap: () => onTap(photo),
      child: CachedNetworkImage(
        imageUrl: photo.path,
        fit: BoxFit.fitWidth,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        placeholder: (context, url) => const ColoredBox(color: Colors.black12),
        memCacheWidth: cachePx,
        memCacheHeight: cachePx,
      ),
    );
  }
}
