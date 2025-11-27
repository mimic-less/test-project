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
import 'widgets/logout_dialog.dart';

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

  Future<void> _showLogoutDialog(BuildContext context) async {
    final result = await showCupertinoDialog<bool?>(
      context: context,
      builder: (context) => const LogoutDialog(),
    );
    if (result == true) await getIt<AuthService>().logout();
  }

  Widget _loadingWidget(bool isLoading) {
    if (!isLoading) return const SizedBox();
    return const SafeArea(child: CircularProgressIndicator());
  }

  void _buttonAction(BuildContext context, Photo photo) {
    context.push('/gallery-screen/image-preview-screen', extra: photo);
  }

  Widget _errorWidget(BuildContext context, String error) {
    if (error.isEmpty) return const SizedBox();
    return SafeArea(
      child: MaterialBanner(
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => context.read<GalleryNotifier>().loadNext(retry: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
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
          builder: (context, notifier, _) => FloatingActionButton(
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
              builder: (context, photos, _) {
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
              builder: (context, isLoading, _) => _loadingWidget(isLoading),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Selector<GalleryNotifier, String>(
                selector: (context, notifier) => notifier.state.error,
                builder: (context, error, _) => _errorWidget(context, error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
