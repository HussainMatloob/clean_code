import 'package:flutter/material.dart';
import 'package:snooker_management/constants/enum_constant.dart';
import 'package:snooker_management/models/sidebar_menu_model.dart';

class DataConstant {
  List<String> modulesName = [
    "Allocation Management",
    "Attendance Management",
    "Employee Management",
    "Expense Management",
    "Membership Management",
    "Package Management",
    "Salary Management",
    "Sale Management",
    "Table Management",
    "Sales,Profit & Loss",
    "LogOut"
  ];

  static List<String> monthsName = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static List<String> reportMethods = [
    "Table Sales",
    "All Expenses",
    "Other Expenses",
    "Profit&Loss",
  ];

  static final List<SidebarMenuItem> menuItems = [
    SidebarMenuItem(
      title: "Allocations",
      icon: Icons.assignment_ind,
      pageIndex: enumPageIndex.AllocationManagement,
      permission: "Allocation Management",
    ),
    SidebarMenuItem(
      title: "Attendance",
      icon: Icons.event_note,
      pageIndex: enumPageIndex.AttendanceManagement,
      permission: "Attendance Management",
    ),
    SidebarMenuItem(
      title: "Employee Management",
      icon: Icons.groups,
      pageIndex: enumPageIndex.EmployeeManagement,
      permission: "Employee Management",
    ),
    SidebarMenuItem(
      title: "Expenses Management",
      icon: Icons.receipt_long,
      pageIndex: enumPageIndex.ExpenseManagement,
      permission: "Expense Management",
    ),
    SidebarMenuItem(
      title: "Membership Management",
      icon: Icons.card_membership,
      pageIndex: enumPageIndex.MembershipManagement,
      permission: "Membership Management",
    ),
    SidebarMenuItem(
      title: "Package Management",
      icon: Icons.inventory_2,
      pageIndex: enumPageIndex.PackageManagement,
      permission: "Package Management",
    ),
    SidebarMenuItem(
      title: "Salary Management",
      icon: Icons.payments,
      pageIndex: enumPageIndex.SalaryManagement,
      permission: "Salary Management",
    ),
    SidebarMenuItem(
      title: "Sales",
      icon: Icons.list_alt,
      pageIndex: enumPageIndex.SalaeManagement,
      permission: "Sale Management",
    ),
    SidebarMenuItem(
      title: "Table Management",
      icon: Icons.grid_view,
      pageIndex: enumPageIndex.TableManagement,
      permission: "Table Management",
    ),
    SidebarMenuItem(
      title: "Sales,Profit & Loss",
      icon: Icons.table_chart,
      pageIndex: enumPageIndex.SalesProfit$Loss,
      permission: "Sales,Profit & Loss",
    ),
  ];
}
