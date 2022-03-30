import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {

  final String imageURL;
  const ImageView(this.imageURL);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Image.network(widget.imageURL);
  }
}
