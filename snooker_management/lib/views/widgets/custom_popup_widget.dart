import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomPopupWidget extends StatelessWidget {
  List<String>? playersName;
  CustomPopupWidget({super.key, this.playersName});
  @override
  Widget build(BuildContext context) {
    return playersName != null
        ? Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: ColorConstant.secondaryColor, // Set your desired color
              ),
            ),
            child: PopupMenuButton(
              color: ColorConstant.whiteColor,
              icon: Icon(
                Icons.error,
                color: ColorConstant.offWhite,
                size: 18.sp,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Column(
                    children: [
                      for (int i = 0; i < playersName!.length; i++)
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomText(
                                playersName![i],
                                size: 12.sp,
                                fw: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
