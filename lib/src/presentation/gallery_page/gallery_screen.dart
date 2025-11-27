import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../config/get_it/get_it.dart';
import '../../domain/models/photo.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../../domain/services/auth_service.dart';
import '../../utils/extensions/scroll_controller_extension.dart';
import 'provider/gallery_notifier.dart';
import 'widgets/grid_view_photo.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final ScrollController _scrollController;
  late int cachePx;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    final dpr = MediaQuery.of(context).devicePixelRatio;

    final cellWidthLogical = width / 3;
    cachePx = (cellWidthLogical * dpr).round();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showLogoutDialog(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Alert'),
        content: const Text('Proceed with this destructive action?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await getIt<AuthService>().logout();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _loadingWidget(bool isLoading) {
    if (!isLoading) return const SizedBox();
    return const SafeArea(child: CircularProgressIndicator());
  }

  void _buttonAction(BuildContext context, Photo photo) {
    context.push('/gallery-screen/image-preview-screen', extra: photo);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final notifier = GalleryNotifier(getIt<GalleryRepository>());
        _scrollController.onScrollEndListener(() => notifier.loadNext());
        return notifier;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Consumer<GalleryNotifier>(
          builder: (context, notifier, child) => FloatingActionButton(
            onPressed: () => notifier.pickAndInsertLocalImage(),
            child: const Icon(Icons.add),
          ),
        ),
        appBar: AppBar(
          title: const Text('GALLERY'),
          actions: [
            IconButton(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Selector<GalleryNotifier, List<Photo>>(
              selector: (context, notifier) => notifier.state.photos,
              builder: (context, photos, child) {
                return GridView.builder(
                  controller: _scrollController,
                  itemCount: photos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    final photo = photos[index];
                    return GridViewPhoto(
                      onTap: (photo) => _buttonAction(context, photo),
                      photo: photo,
                      cachePx: cachePx,
                    );
                  },
                );
              },
            ),
            Selector<GalleryNotifier, bool>(
              selector: (context, notifier) => notifier.state.isLoading,
              builder: (context, value, child) => _loadingWidget(value),
            ),
          ],
        ),
      ),
    );
  }
}
