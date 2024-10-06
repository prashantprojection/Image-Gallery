import 'package:flutter/material.dart';
import 'package:gallery_view/widgets/image_downloader.dart';
import '../models/image_model.dart';

void showFullScreenImageDialog(BuildContext context,
    {required ImageModel image}) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero, // Make dialog cover full screen
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                image.largeImageURL,
                fit: BoxFit.contain, // Ensure image covers the entire dialog
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                label: const Text('Download'),
                icon: const Icon(Icons.download),
                onPressed: () {
                  // Show the download options dialog using DownloadHelper
                  ImageDownloader.showDownloadOptions(
                      context, image.resolutions);
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
