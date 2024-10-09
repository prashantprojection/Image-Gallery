import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/image_model.dart';
import '../controllers/image_controller.dart';

final imageProvider =
    StateNotifierProvider<ImageNotifier, List<ImageModel>>((ref) {
  return ImageNotifier();
});

class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  bool _isLoading = false;
  bool _hasMoreImages = true;
  int _currentPage = 1;
  String _searchQuery = "";
  final ImageController _imageController = ImageController();

  Future<void> fetchImages({String? searchQuery}) async {
    if (_isLoading || !_hasMoreImages) return;

    if (searchQuery != null && searchQuery != _searchQuery) {
      _searchQuery = searchQuery;
      reset(); // Reset state when new search query is made
    }

    _isLoading = true;

    try {
      final newImages = await _imageController.fetchImages(
        page: _currentPage,
        searchQuery: _searchQuery,
      );

      if (newImages.isNotEmpty) {
        state = [...state, ...newImages];
        _currentPage++;
      } else {
        _hasMoreImages = false;
      }
    } catch (error) {
      print('Failed to load images: $error');
    } finally {
      _isLoading = false;
    }
  }

  bool get isLoading => _isLoading;
  bool get hasMoreImages => _hasMoreImages;

  void reset() {
    state = [];
    _isLoading = false;
    _hasMoreImages = true;
    _currentPage = 1;
  }
}
