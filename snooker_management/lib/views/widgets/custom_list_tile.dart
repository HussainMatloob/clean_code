import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomListTile extends StatelessWidget {
  final double? padding;
  final double? height;
  final double? width;
  final String? image;
  final String? text;
  final String? leadingText;
  final double? textSize;
  final Color? textColor;
  final FontWeight? textFw;
  final VoidCallback? onTap;
  final bool? isAsset;
  final bool? isText;
  final Icon? icon;
  const CustomListTile(
      {super.key,
      this.padding,
      this.height,
      this.width,
      this.image,
      this.text,
      this.textSize,
      this.textColor,
      this.textFw,
      this.onTap,
      this.isAsset = false,
      this.isText = false,
      this.leadingText,
      this.icon});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: isText == true
          ? CustomText(
              leadingText,
              size: textSize,
              fw: textFw,
              color: textColor,
            )
          : icon,
      // CustomImageWidget(
      //     isAsset: isAsset,
      //     width: width,
      //     height: height,
      //     image: image,
      //   ),
      title: isText == true
          ? const SizedBox()
          : CustomText(
              text,
              size: textSize,
              fw: textFw,
              color: textColor,
            ),
      trailing: isText == true
          ? CustomText(
              text,
              size: textSize,
              fw: textFw,
              color: textColor,
            )
          : const SizedBox(),
    );
  }
}
