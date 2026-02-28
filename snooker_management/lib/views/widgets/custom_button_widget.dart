import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomButtonWidget extends StatelessWidget {
  final Color? buttonColor;
  final double? height;
  final double? width;
  final String? text;
  final double? textSize;
  final FontWeight? textFw;
  final Color? textColor;
  VoidCallback? tabAction;
  final double? radius;
  final double? paddingHorizontal;

  final Icon? icon;
  final double? sizedBoxWidth;
  final bool? isBorder;

  CustomButtonWidget(
      {super.key,
      this.tabAction,
      this.buttonColor,
      this.height,
      this.width,
      this.text,
      this.textSize,
      this.textFw,
      this.textColor,
      this.radius,
      this.paddingHorizontal,
      this.icon,
      this.sizedBoxWidth,
      this.isBorder = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tabAction,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0.r),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius ?? 5.r),
            border: isBorder == true
                ? Border.all(width: 1.w, color: ColorConstant.greyColor)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: icon,
              ),
              SizedBox(
                width: sizedBoxWidth,
              ),
              CustomText(
                text ?? "",
                size: textSize,
                color: textColor ?? ColorConstant.whiteColor,
              ),
            ],
          )),
    );
  }
}
