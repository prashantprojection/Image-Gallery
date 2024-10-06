import 'dart:html' as html;
import 'package:flutter/material.dart';

Future<void> downloadImage(
    String url, BuildContext context, int width, int height) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('Downloading image in ${width}x${height} resolution...'),
  ));

  // Create a new anchor element to trigger the download
  final html.AnchorElement anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "image_${width}x${height}.jpg")
    ..click();

  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Download started'),
  ));
}
