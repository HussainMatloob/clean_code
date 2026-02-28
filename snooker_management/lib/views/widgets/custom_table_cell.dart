import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
class CustomTableCell extends StatelessWidget {
  final double? padding;
  final String? text;
  final Color? textColor;
  final FontWeight? textFw;
  final double? textSize;
  const CustomTableCell({super.key, this.padding, this.text, this.textColor, this.textFw, this.textSize});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.all(padding??0.r),
      child: Center(child: CustomText(text,fw: textFw,color: textColor,),),
    );
  }
}
