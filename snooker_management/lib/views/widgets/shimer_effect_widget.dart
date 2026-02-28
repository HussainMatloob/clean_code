import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:snooker_management/main.dart';

class ShimmerEffectWidget extends StatelessWidget {
  const ShimmerEffectWidget({super.key});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return ListView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 7, // Use actual item count
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
            baseColor: Colors.grey.shade700,
            highlightColor: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
                  height: 50.h,
                  width: 50.w,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 10.h,
                      width: 100.w,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 10.h,
                      width: 70.w,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ));
      },
    );
  }
}
