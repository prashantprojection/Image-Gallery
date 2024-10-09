import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_view/utils/categories.dart';
import '../models/image_model.dart';
import '../widgets/image_card.dart';
import '../providers/image_provider.dart';
import '../providers/category_provider.dart'; // Ensure you have your category provider imported
import 'category_images_view.dart';

class GalleryView extends ConsumerStatefulWidget {
  @override
  _GalleryViewState createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView> {
  final ScrollController _scrollController = ScrollController();
  bool _isDataReady = false;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = Categories().categories;

  @override
  void initState() {
    super.initState();
    _fetchInitialImages();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchInitialImages() async {
    await Future.delayed(const Duration(seconds: 2), () async {
      await ref.read(imageProvider.notifier).fetchImages();
      setState(() {
        _isDataReady = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkIfMoreImagesNeeded();
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(imageProvider.notifier).fetchImages();
    }
  }

  void _checkIfMoreImagesNeeded() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent == 0) {
      ref.read(imageProvider.notifier).fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            title: Text(
              "Gallery View",
              textScaleFactor: 2,
            ),
            centerTitle: true,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: height,
                  child: TextField(
                    expands: false,
                    maxLines: 1,
                    controller: _searchController,
                    onSubmitted: (query) {
                      ref
                          .read(imageProvider.notifier)
                          .reset(); // Reset before searching
                      ref
                          .read(imageProvider.notifier)
                          .fetchImages(searchQuery: query);
                    },
                    decoration: InputDecoration(
                      hintText: "Type something to Search...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: _categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: false,
                          onSelected: (_) {
                            ref.read(categoryProvider.notifier).fetchImages(
                                searchQuery:
                                    category); // Update selected category

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryImagesView(category: category),
                              ),
                            ).then((_) {
                              ref
                                  .read(categoryProvider.notifier)
                                  .reset(); // Clear the selected category when coming back
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: _isDataReady
                ? _buildGallery(context)
                : _buildSplashScreen(context),
          ),
        ],
      ),
    );
  }

  Widget _buildGallery(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final images = ref.watch(imageProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: _scrollController,
        crossAxisCount: (width ~/ height) + 2, // Adjust for proper grid layout
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return ImageCard(image: images[index]);
        },
      ),
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
