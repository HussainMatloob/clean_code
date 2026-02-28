import 'package:flutter/material.dart';
import 'package:snooker_management/constants/color_constants.dart';

class CustomRippleButton extends StatefulWidget {
  const CustomRippleButton({super.key});

  @override
  State<CustomRippleButton> createState() => _CustomRippleButtonState();
}

class _CustomRippleButtonState extends State<CustomRippleButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  final List<double> listRadius = [40.0, 50.0, 62.0, 75.0, 112.0];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 3),
        lowerBound: 0.5 // Run every second
        );

    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {}); // Rebuild to update ripple effect
      });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
        _animationController.forward(); // Restart the animation
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: listRadius.map((radius) {
          return Container(
            width: radius * _animation.value,
            height: radius * _animation.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstant.primaryColor
                  .withOpacity(1.0 - _animation.value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
