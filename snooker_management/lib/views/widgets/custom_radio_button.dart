import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';

class CustomRadioButton<T extends GetxController> extends StatelessWidget {
  final String? status;
  final T controller;
  final bool isAllocation;
  const CustomRadioButton({super.key, this.status, required this.controller,  this.isAllocation=false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init:controller,
      builder: (radioButtonController){
        final customController = radioButtonController as dynamic;
        return Row(
          children: [
            Radio(
              value: status,
              groupValue: customController.selectedStatus,
              onChanged: (value) {
                customController.selectStatus(value!);
              },
            ),
            CustomText(status.toString(),size: isAllocation?12.sp:16.sp,color:ColorConstant.hintTextColor,),
          ],
        );
      },
    );
  }
}
