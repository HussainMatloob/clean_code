import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/main.dart';
import 'package:snooker_management/utils/helper/responsive_helper.dart';
import 'package:snooker_management/views/widgets/custom_text.dart';
import 'package:snooker_management/views/widgets/custom_text_form_field.dart';

class EditAbleCustomDropDownButton<T extends GetxController>
    extends StatefulWidget {
  final double? dropDownListTextSize;
  final double? height;
  final double? width;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textFw;
  final List<String> dropDownButtonList;
  final String? text;
  final T controller;
  final TextEditingController customFieldController;
  final bool isAllocation;
  final double? hintTextSize;
  final bool isValidateTrue;
  const EditAbleCustomDropDownButton(
      {super.key,
      required this.dropDownButtonList,
      this.text,
      this.height,
      this.width,
      this.textColor,
      this.textSize,
      this.textFw,
      required this.controller,
      this.dropDownListTextSize,
      required this.customFieldController,
      this.isAllocation = false,
      this.hintTextSize,
      this.isValidateTrue = true});
  @override
  State<EditAbleCustomDropDownButton> createState() =>
      _EditAbleCustomDropDownButtonStateState<T>();
}

class _EditAbleCustomDropDownButtonStateState<T extends GetxController>
    extends State<EditAbleCustomDropDownButton<T>> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return GetBuilder<T>(
      init: widget.controller,
      builder: (controller) {
        final customController = controller as dynamic;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              hintTextSize: widget.hintTextSize,
              validateFunction: widget.isValidateTrue
                  ? customController.customFieldsValidate
                  : null,
              horizontalPadding: 10.w,
              controller: widget.customFieldController,
              labelText: widget.text,
              suffixWidget: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  items: widget.dropDownButtonList
                      .map(
                        (String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: widget.dropDownListTextSize,
                              color: ColorConstant.hintTextColor,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    widget.isAllocation
                        ? customController.selectValueFromEditableDropDown(
                            value, widget.customFieldController)
                        : customController
                            .selectValueFromEditableDropDown(value);
                  },
                  buttonStyleData: ButtonStyleData(
                    width: widget.width ?? 30.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // important
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    elevation: 0, // remove shadow
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: mq.height * 0.2,
                    width: widget.width ??
                        311.w, // Let it automatically adjust to button width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: ColorConstant.greenLightColor,
                    ),
                    offset: Offset(
                        ResponsiveHelper.isMobile(context) ? -200 : -300,
                        0), // Adjust based on your need, initially try (0, 0)
                    scrollbarTheme: ScrollbarThemeData(
                      radius: const Radius.circular(40),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50.h,
                    searchInnerWidget: Container(
                      height: 50.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          hintText: 'Search here...',
                          hintStyle: TextStyle(fontSize: 14.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value
                          .toString()
                          .toLowerCase()
                          .contains(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                  },
                ),
              ),
              onChanged: (value) {
                if (!widget.isAllocation) {
                  customController.updateFunction();
                }
              },
            ),
            const SizedBox(height: 8),
            if (!widget.dropDownButtonList
                    .contains(widget.customFieldController.text) &&
                widget.customFieldController.text.trim().isNotEmpty)
              widget.isAllocation
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () {
                        customController.addCustomExpense(context);
                      },
                      child: CustomText('Add to list'),
                    )
          ],
        );
      },
    );
  }
}
