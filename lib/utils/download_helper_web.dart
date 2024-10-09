import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> downloadImage(
    String url, BuildContext context, int width, int height) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Downloading image in ${width}x${height} resolution...'),
    ));

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final fileData = html.Blob([response.bodyBytes]);
      final fileUrl = html.Url.createObjectUrlFromBlob(fileData);

      html.AnchorElement(href: fileUrl)
        ..setAttribute('download', 'image_${width}x${height}.jpg')
        ..click();

      html.Url.revokeObjectUrl(fileUrl);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Download started.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to download image: ${response.statusCode}'),
      ));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error downloading image: ${e.toString()}'),
    ));
  }
}
