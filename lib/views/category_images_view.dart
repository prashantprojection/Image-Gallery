import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_view/providers/category_provider.dart';
import '../models/image_model.dart';
import '../widgets/image_card.dart';
import '../providers/image_provider.dart';

class CategoryImagesView extends ConsumerStatefulWidget {
  final String category;

  const CategoryImagesView({Key? key, required this.category})
      : super(key: key);

  @override
  _CategoryImagesViewState createState() => _CategoryImagesViewState();
}

class _CategoryImagesViewState extends ConsumerState<CategoryImagesView> {
  final ScrollController _scrollController = ScrollController();
  bool _isDataReady = false;

  @override
  void initState() {
    super.initState();
    _fetchCategoryImages();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchCategoryImages() async {
    await ref
        .read(categoryProvider.notifier)
        .fetchImages(searchQuery: widget.category);
    setState(() {
      _isDataReady = true;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref
          .read(categoryProvider.notifier)
          .fetchImages(searchQuery: widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final images = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: _isDataReady
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MasonryGridView.count(
                controller: _scrollController,
                crossAxisCount: (width ~/ height) + 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return ImageCard(image: images[index]);
                },
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
