import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../main.dart';

class CustomImageSelector<T extends GetxController> extends StatefulWidget {
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final Icon? icon;
  final String? image;
  final T controller;
  const CustomImageSelector(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.color,
      this.icon,
      this.image,
      required this.controller});
  @override
  State<CustomImageSelector> createState() => _CustomImageSelectorState<T>();
}

class _CustomImageSelectorState<T extends GetxController>
    extends State<CustomImageSelector<T>> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<T>(
      init: widget.controller,
      builder: (imageController) {
        // Cast controller to its specific type
        final typedController = imageController as dynamic;
        return InkWell(
            onTap: () async {
              if (typedController.imagePicker != null) {
                await typedController.imagePicker(); // Call the method
              } else {}
            },
            child: typedController.newImage == null && widget.image != null
                ? kIsWeb
                    ? Image.network(
                        widget.image!,
                        height: widget.height,
                        width: widget.width,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                              height: widget.height,
                              width: widget.width,
                              child:
                                  Icon(Icons.broken_image, color: Colors.grey));
                        },
                      )
                    : CachedNetworkImage(
                        height: widget.height,
                        width: widget.width,
                        imageUrl: widget.image!,
                        fit: BoxFit.cover,
                      )
                : Container(
                    height: widget.height,
                    width: widget.width,
                    color: widget.color,
                    child: typedController.newImage == null
                        ? widget.icon
                        : Image.memory(
                            typedController.newImage!,
                            fit: BoxFit.cover,
                          ),
                  ));
      },
    );
  }
}
