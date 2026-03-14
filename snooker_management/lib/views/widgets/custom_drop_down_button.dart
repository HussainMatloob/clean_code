import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:snooker_management/constants/color_constants.dart';
import 'package:snooker_management/main.dart';

class CustomDropDownButton<T extends GetxController> extends StatefulWidget {
  final double? dropDownListTextSize;
  final double? height;
  final double? width;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textFw;
  final List<String>? dropDownButtonList;
  final String? text;
  final bool? isShowingCustomNames;
  final T controller;
  final bool? isEmployee;
  final bool? isSearching;
  final bool? isMonthsOrTables;
  final bool? isTableNumber;
  const CustomDropDownButton({
    super.key,
    this.dropDownButtonList,
    this.text,
    this.height,
    this.width,
    this.textColor,
    this.textSize,
    this.textFw,
    this.isShowingCustomNames = false,
    this.dropDownListTextSize,
    required this.controller,
    this.isEmployee = false,
    this.isSearching = false,
    this.isMonthsOrTables = false,
    this.isTableNumber = false,
  });
  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState<T>();
}

class _CustomDropDownButtonState<T extends GetxController>
    extends State<CustomDropDownButton<T>> {
  late MediaQueryData mediaQuery;
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
      builder: (dropDownController) {
        final customController = dropDownController as dynamic;
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              children: [
                SizedBox(
                  width: 5.w,
                ),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    widget.text ?? '',
                    style: TextStyle(
                      fontWeight: widget.textFw,
                      fontSize: widget.textSize,
                      color: widget.textColor,
                    ),
                  ),
                ),
              ],
            ),
            items: widget.dropDownButtonList!
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
            value: widget.isMonthsOrTables!
                ? customController.selectedMonthOrTable
                : widget.isSearching!
                    ? customController.selectedSearchedName
                    : widget.isEmployee == true
                        ? customController.selectedEmployeeShift
                        : widget.isShowingCustomNames == true
                            ? customController.selectedCustomName
                            : customController.selectedPackageName,
            onChanged: (value) {
              if (widget.isEmployee == true) {
                customController.selectEmployeeShiftInDropDownList(
                    context, value.toString());
              } else if (widget.isMonthsOrTables!) {
                if (widget.isTableNumber!) {
                  customController.selectTable(value.toString(), context);
                } else {
                  customController.selectMonth(value.toString());
                }
              } else if (widget.isSearching!) {
                customController.selectValueForSearch(value.toString());
              } else {
                customController.selectDropDownListValue(
                  value.toString(),
                  widget.isShowingCustomNames!,
                );
              }
            },
            buttonStyleData: ButtonStyleData(
              height: widget.height ?? 57.h,
              width: widget.width ?? 311.w,
              padding: EdgeInsets.only(
                left: 10.w,
                right: 5.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.transparent),
                color: ColorConstant.greenLightColor,
              ),
              elevation: 2,
            ),
            iconStyleData: IconStyleData(
              icon: const Icon(Icons.keyboard_arrow_down_sharp),
              iconSize: 20,
              iconEnabledColor: ColorConstant.hintTextColor,
              iconDisabledColor: ColorConstant.hintTextColor,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: mq.height * 0.2,
              width: null, // Let it automatically adjust to button width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstant.greenLightColor,
              ),
              offset: const Offset(
                  0, 0), // Adjust based on your need, initially try (0, 0)
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all(6),
                thumbVisibility: WidgetStateProperty.all(true),
              ),
            ),
            dropdownSearchData: widget.isEmployee == true
                ? null
                : DropdownSearchData(
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
        );
      },
    );
  }
}
