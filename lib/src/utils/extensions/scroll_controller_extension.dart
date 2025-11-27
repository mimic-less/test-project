import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  void onScrollEndListener(final VoidCallback callback) {
    addListener(() {
      if (position.pixels >= position.maxScrollExtent - 200) {
        callback();
      }
    });
  }
}
