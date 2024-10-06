import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_view/widgets/full_screen_bottom_sheet.dart';
import '../providers/image_provider.dart';

class GalleryView extends ConsumerStatefulWidget {
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView> {
  final ScrollController _scrollController = ScrollController();
  bool _isDataReady = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      await ref.read(imageProvider.notifier).fetchImages();
      setState(() {
        _isDataReady = true; // Data is ready, show the gallery
      });

      // Ensure images load for large screens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkIfMoreImagesNeeded();
      });
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Trigger fetch when scrolled to the bottom
      ref.read(imageProvider.notifier).fetchImages();
    }
  }

  // Check if the grid fills the screen on large screens and load more images if necessary
  void _checkIfMoreImagesNeeded() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent == 0) {
      // No scrolling available, fetch more images
      ref.read(imageProvider.notifier).fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galley View"),
      ),
      body: _isDataReady ? _buildGallery(context) : _buildSplashScreen(context),
    );
  }

  Widget _buildGallery(BuildContext context) {
    final images = ref.watch(imageProvider);
    final isLoading = ref
        .watch(imageProvider.notifier.select((provider) => provider.isLoading));
    final hasMoreImages = ref.watch(
        imageProvider.notifier.select((provider) => provider.hasMoreImages));

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 350,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return GestureDetector(
                    onTap: () {
                      // Open full-screen bottom sheet when an image is tapped
                      showFullScreenImageDialog(context, image: image);
                    },
                    child: Card(
                      borderOnForeground: true,
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Image.network(
                              image.webformatURL,
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
                                    const SizedBox(width: 4),
                                    Text('${image.likes}'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.solidEye,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('${image.views}'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (isLoading && hasMoreImages)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(), // Show loading indicator
          ),
        if (!hasMoreImages)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No more images to load.'),
          ),
      ],
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return Container(
      color: Colors.white, // Splash screen background color
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(), // Replace with your animation or logo if needed
            SizedBox(height: 16),
            Text(
              'Loading images...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
