import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:snooker_management/constants/color_constants.dart';

import '../../main.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? message;
  final String? hintText;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double? width;
  final double? height;
  final bool isPassword;
  final Color? color;
  final FocusNode? focusNode;
  final Color? fillColor;
  final double? hintTextSize;
  final Color? hintTextColor;
  final FontWeight? hintTextFw;
  final double? borderRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final Widget? child;
  final bool? isObSecure;
  final VoidCallback? suffixTapAction;
  final Function(dynamic value)? onChanged;
  final String? Function(String?)? validateFunction;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool? isMultiline;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Icon? visibilityOffIcon;
  final Icon? icon;
  final bool? fieldEnable;
  final Widget? suffixWidget;
  final Icon? prefixIcon;
  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.message,
    this.borderColor = const Color(0XFFF1F8E9),
    this.focusedBorderColor = const Color(0XFFF1F8E9),
    this.errorBorderColor = Colors.red,
    this.width,
    this.height,
    this.isPassword = false,
    this.color,
    this.focusNode,
    this.fillColor,
    this.hintTextSize,
    this.hintTextColor,
    this.hintTextFw,
    this.borderRadius,
    this.horizontalPadding,
    this.verticalPadding,
    this.child,
    this.isObSecure,
    this.onChanged,
    this.hintStyle,
    this.suffixTapAction,
    this.validateFunction,
    this.isMultiline = false,
    this.onTap,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.labelStyle,
    this.visibilityOffIcon,
    this.icon,
    this.fieldEnable = true,
    this.suffixWidget,
    this.prefixIcon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.sizeOf(context);
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          maxLines: widget.isMultiline == true ? null : 1,
          obscureText:
              widget.isObSecure ?? false, // Toggle visibility based on state
          obscuringCharacter: "*",
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: widget.isMultiline == false
              ? TextInputType.text
              : TextInputType.multiline,
          controller: widget.controller,
          decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: widget.labelStyle ??
                  TextStyle(
                    fontWeight: widget.hintTextFw ?? FontWeight.w400,
                    fontSize: widget.hintTextSize ?? 16.sp,
                    color: widget.hintTextColor ?? const Color(0xFF9E9E9E),
                  ),
              hintStyle: widget.hintStyle ??
                  TextStyle(
                    fontWeight: widget.hintTextFw ?? FontWeight.w400,
                    fontSize: widget.hintTextSize ?? 16.sp,
                    color: widget.hintTextColor ?? const Color(0xFF9E9E9E),
                  ),
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 10.r),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 10.r),
                borderSide:
                    BorderSide(color: widget.focusedBorderColor, width: 2.0.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 10.r),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 10.r),
                borderSide: BorderSide(color: widget.errorBorderColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 10.r),
                borderSide:
                    BorderSide(color: widget.errorBorderColor, width: 2.0.w),
              ),
              prefixIcon: widget.child == null
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        widget.child!,
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
              prefix: widget.prefixIcon,
              suffixIcon: widget.suffixWidget ??
                  (widget.suffixTapAction != null
                      ? InkWell(
                          onTap: widget.suffixTapAction,
                          child: widget.visibilityOffIcon == null
                              ? widget.icon
                              : widget.isObSecure!
                                  ? widget.visibilityOffIcon!
                                  : widget.icon)
                      : null),
              fillColor: widget.fillColor ?? ColorConstant.greenLightColor,
              filled: true,
              enabled: widget.fieldEnable!,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding ?? 0.h,
                horizontal: widget.horizontalPadding ?? 0.w,
              )),
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          inputFormatters: widget.inputFormatters,
          validator: widget.validateFunction),
    );
  }
}
