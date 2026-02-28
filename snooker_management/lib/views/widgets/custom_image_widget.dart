import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';

class CustomImageWidget extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final Color? color;
  final bool? isAsset;
  final bool? isAllocated;
  final String? tableImage;
  final double? radius;
  const CustomImageWidget(
      {super.key,
      this.image,
      this.width,
      this.color,
      this.height,
      this.isAsset = false,
      this.isAllocated = false,
      this.tableImage,
      this.radius});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 0.r),
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0.r),
        child: isAsset == true
            ? Image.asset(
                image ?? "",
                height: height,
                width: width,
                fit: BoxFit.fill,
                color: tableImage == "tableImage"
                    ? isAllocated!
                        ? null
                        : Colors.black.withOpacity(0.5)
                    : null,
                colorBlendMode: tableImage == "tableImage"
                    ? isAllocated!
                        ? null
                        : BlendMode.darken
                    : null,
              )
            : CachedNetworkImage(
                height: height,
                width: width,
                imageUrl: image ?? "",
                fit: BoxFit.fill,
                color: tableImage == "tableImage"
                    ? isAllocated!
                        ? null
                        : Colors.black.withOpacity(0.5)
                    : null, // Apply dim color
                colorBlendMode: tableImage == "tableImage"
                    ? isAllocated!
                        ? null
                        : BlendMode.darken
                    : null, // Blend mode for dimming effect
                placeholder: isAsset == true
                    ? null
                    : (context, url) => Center(
                          child: Container(
                            padding: EdgeInsets.all(20.r),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConstant.primaryColor,
                            ),
                          ), // Placeholder for loading
                        ),
                errorWidget: (context, url, error) {
                  return Icon(
                    Icons.image,
                    size: 20.sp,
                    color: ColorConstant.greyColor,
                  );
                },
              ),
      ),
    );
  }
}
