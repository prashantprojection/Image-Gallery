import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_view/models/image_model.dart';

import '../views/full_screen_bottom_sheet.dart';

class ImageCard extends StatefulWidget {
  const ImageCard({required this.image, super.key});

  final ImageModel image;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool isHovering = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (hover) {
        setState(() {
          isHovering = hover;
        });
      },
      onTap: () {
        // Open full-screen bottom sheet when an image is clicked/tapped
        showFullScreenImageDialog(context, image: widget.image);
      },
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            margin: EdgeInsets.all(isHovering ? 12 : 20),
            foregroundDecoration: isHovering
                ? const BoxDecoration(
                    backgroundBlendMode: BlendMode.darken,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black87,
                          Colors.transparent,
                          Colors.black87,
                        ]))
                : const BoxDecoration(),
            child: Image.network(
              widget.image.webformatURL,
              fit: BoxFit.contain,
            ),
          ),
          if (isHovering)
            Positioned(
                top: 2.5,
                right: 12,
                child: IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.bookmark,
                      color: Colors.white,
                    ))),
        ],
      ),
    );
    ;
  }
}
