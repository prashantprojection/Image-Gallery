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
  final ImageController _imageController = ImageController();

  // Method to fetch images
  Future<void> fetchImages() async {
    // Prevent multiple API requests at the same time
    if (_isLoading || !_hasMoreImages) return;

    _isLoading = true;

    try {
      // Fetch new images from the API
      final newImages = await _imageController.fetchImages(_currentPage);

      // If new images are received, append them to the current state
      if (newImages.isNotEmpty) {
        state = [...state, ...newImages];
        _currentPage++; // Move to the next page
      } else {
        // If no new images are received, stop further requests
        _hasMoreImages = false;
      }
    } catch (error) {
      print('Failed to load images: $error');
    } finally {
      _isLoading = false;
    }
  }

  // Getter to check if loading is in progress
  bool get isLoading => _isLoading;

  // Getter to check if there are more images to load
  bool get hasMoreImages => _hasMoreImages;

  // Reset the provider completely and reload images from start
  void reset() {
    state = [];
    _isLoading = false;
    _hasMoreImages = true;
    _currentPage = 1;
    fetchImages();
  }
}
