import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/image_provider.dart';

class GalleryView extends ConsumerStatefulWidget {
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(imageProvider.notifier).fetchImages(); // Fetch initial images
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Fetch more images when scrolled to the bottom
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(imageProvider.notifier).fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);
    final isLoading = ref
        .watch(imageProvider.notifier.select((provider) => provider.isLoading));
    final hasMoreImages = ref.watch(
        imageProvider.notifier.select((provider) => provider.hasMoreImages));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(imageProvider.notifier).reset();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 350,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Card(
                  borderOnForeground: true,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Image.network(
                          image.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text('${image.likes}'),
                              ],
                            ),
                            Row(
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.solidEye,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text('${image.views}'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (isLoading && hasMoreImages)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(), // Show loading indicator
            ),
          // If Page don't have anymore images to load then showing a simple text at bottom of the page
          if (!hasMoreImages)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No more images to load.'),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
