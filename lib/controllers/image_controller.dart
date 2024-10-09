import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/image_model.dart';

class ImageController {
  final String _apiKey = '46271742-b02b9c5c5541f922bede1c54a';
  final String _baseUrl = 'https://pixabay.com/api/';

  Future<List<ImageModel>> fetchImages({
    required int page,
    String searchQuery = "",
  }) async {
    final response = await http.get(
      Uri.parse(
          '$_baseUrl?key=$_apiKey&q=$searchQuery&image_type=photo&page=$page'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> hits = jsonData['hits'];
      return hits.map((hit) => ImageModel.fromJson(hit)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
