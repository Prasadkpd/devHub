import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  const CustomImage({super.key, 
    this.imageUrl,
    this.height = double.infinity,
    this.width = double.infinity,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
      height: height,
      fit: fit,
      width: width,
    );
  }
}
