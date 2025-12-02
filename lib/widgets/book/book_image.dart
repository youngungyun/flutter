import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookImage extends StatelessWidget {
  final String imageUrl;
  final int imageWidth;
  final int imageHeight;

  const BookImage({
    super.key,
    required this.imageUrl,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 120,
      height: 174,
      placeholder: (context, url) => Container(
        width: 120,
        height: 174,
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => Container(
        width: 120,
        height: 174,
        color: Theme.of(context).colorScheme.onError,
        child: const Icon(Icons.broken_image, size: 40),
      ),
    );
  }
}
