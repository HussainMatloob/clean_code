import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorConstant.greyColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ColorConstant.linearGradian,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 404 Text
                Text(
                  "404",
                  style: TextStyle(
                    fontSize: size.width > 600 ? 50.sp : 48.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),

                // Page Not Found
                Text(
                  "Page Not Found",
                  style: TextStyle(
                    fontSize: size.width > 600 ? 25.sp : 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),

                // Subtext
                Text(
                  "The site configured at this address does not contain the requested file.\n"
                  "If this is your site, make sure that the filename case matches the URL as well as any file permissions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width > 600 ? 16.sp : 14.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
