import 'package:flutter/material.dart';
import 'package:snooker_management/constants/enum_constant.dart';

class SidebarMenuItem {
  final String title;
  final IconData icon;
  final enumPageIndex pageIndex;
  final String permission; // permission name
  SidebarMenuItem({
    required this.title,
    required this.icon,
    required this.pageIndex,
    required this.permission,
  });
}
