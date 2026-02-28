import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
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
            } else {
              print("Error: imagePicker is not defined in the controller.");
            }
          },
          child: typedController.newImage == null && widget.image != null
              ? CachedNetworkImage(
                  height: widget.height,
                  width: widget.width,
                  imageUrl: widget.image!,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const Center(
                    child:
                        CircularProgressIndicator(), // Placeholder for loading
                  ),
                  errorWidget: (context, url, error) {
                    return Icon(
                      Icons.error,
                      size: 30.sp,
                      color: ColorConstant.greyColor,
                    );
                  },
                )
              : Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    color: widget.color,
                  ),
                  child: ClipRRect(
                    child: typedController.newImage == null
                        ? widget.icon
                        : Image.memory(
                            typedController.newImage!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
        );
      },
    );
  }
}
