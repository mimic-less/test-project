import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/models/photo.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({required this.photo, super.key});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    if (photo.isLocal) {
      return Image.file(File(photo.path), fit: BoxFit.contain);
    }
    return CachedNetworkImage(
      imageUrl: photo.path,
      fit: BoxFit.contain,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    );
  }
}
