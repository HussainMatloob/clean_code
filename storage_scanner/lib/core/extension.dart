import 'scale.dart';

extension ResponsiveExt on num {
  double get w => Scale.w(this);
  double get h => Scale.h(this);
  double get sp => Scale.sp(this);
  double get r => Scale.r(this);
}
