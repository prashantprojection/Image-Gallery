import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadImage(
    String url, BuildContext context, int width, int height) async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Downloading image in ${width}x${height} resolution...'),
      ));

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/image_${width}x${height}.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Image saved to $filePath'),
        ));
      } else {
        throw Exception('Failed to download image.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Permission denied to save image.'),
    ));
  }
}
