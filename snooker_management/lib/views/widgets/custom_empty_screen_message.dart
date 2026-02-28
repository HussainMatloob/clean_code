import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomEmptyScreenMessage extends StatelessWidget {
  final String? headText;
  final String? subtext;
  final Icon icon;
  final VoidCallback? onTap;
  const CustomEmptyScreenMessage(
      {super.key, this.headText, this.subtext, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 10.h),
          CustomText(
            headText,
            fw: FontWeight.bold,
            size: 16.sp,
            color: ColorConstant.originalGray,
          ),
          const SizedBox(height: 5),
          CustomText(
            subtext,
            size: 12.sp,
            color: ColorConstant.originalGray,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Visibility(
            visible: onTap != null,
            child: TextButton(
                onPressed: onTap,
                child: CustomText(
                  "Login",
                  size: 12.sp,
                  fw: FontWeight.w400,
                  color: ColorConstant.primaryColor,
                )),
          )
        ],
      ),
    );
  }
}
