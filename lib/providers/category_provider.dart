import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallery_view/models/image_model.dart';
import 'package:gallery_view/providers/image_provider.dart';

final categoryProvider =
    StateNotifierProvider<ImageNotifier, List<ImageModel>>((ref) {
  return ImageNotifier();
});
