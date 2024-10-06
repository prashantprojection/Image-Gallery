import 'package:flutter/material.dart';
import '../models/image_model.dart';
import '../utils/download_helper.dart'; // Import the conditional helper

class ImageDownloader {
  static void showDownloadOptions(
      BuildContext context, List<ImageResolution> resolutions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Options'),
          content: Wrap(
            spacing: 8,
            children: resolutions.map((resolution) {
              return ActionChip(
                label: Text('${resolution.width}x${resolution.height}'),
                onPressed: () {
                  Navigator.pop(context);
                  downloadImage(resolution.url, context, resolution.width,
                      resolution.height);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
