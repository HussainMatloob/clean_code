import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:snooker_management/controller/auth_controller.dart';

import 'package:snooker_management/routes/router_refresh_notifire.dart';
import 'package:snooker_management/views/authentication/honour_permissions_screen.dart';

import 'package:snooker_management/views/authentication/login_screen.dart';
import 'package:snooker_management/views/screens/admin_profile_screen.dart';

import 'package:snooker_management/views/screens/allocation_management/allocation_pdf_preview.dart';
import 'package:snooker_management/views/screens/attendance_management/attendance_pdf_preview.dart';
import 'package:snooker_management/views/screens/attendance_management/search_attendance_screen.dart';
import 'package:snooker_management/views/screens/employee_management/employee_pdf_preview.dart';
import 'package:snooker_management/views/screens/expense_management/expenses_pdf_preview.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/other_expenses_pdf_preview.dart';
import 'package:snooker_management/views/screens/expense_management/other_expenses/other_expenses_screen.dart';
import 'package:snooker_management/views/screens/expense_management/search_expense_screen.dart';
import 'package:snooker_management/views/screens/home_page.dart';
import 'package:snooker_management/views/screens/membership_management/members_pdf_preview.dart';
import 'package:snooker_management/views/screens/salary_management/salary_pdf_preview.dart';
import 'package:snooker_management/views/screens/salary_management/search_salary_screen.dart';
import 'package:snooker_management/views/screens/sale_management/reports_and_sale_table_wise.dart';
import 'package:snooker_management/views/screens/sale_management/sales_pdf_preview.dart';
import 'package:snooker_management/views/screens/table_management/table_pdf_preview.dart';

class AppRouter {
  static final AuthenticationController authenticationController =
      Get.find<AuthenticationController>();
  static bool _isFirstLoad = true;
  static GoRouter router(AuthStateNotifier authNotifier) => GoRouter(
        initialLocation: '/login',
        refreshListenable: authNotifier,
        redirect: (context, state) {
          final loggedIn = authenticationController.isLoggedIn;
          final path = state.uri.path;

          //  Not logged in → block protected routes
          if (!loggedIn && path.startsWith('/app')) {
            return '/login?denied=true';
          }

          //  Logged in → prevent going back to login
          if (loggedIn && path == '/login') {
            return '/app/home';
          }

          //  If app just restarted (browser refresh)
          if (loggedIn && _isFirstLoad) {
            _isFirstLoad = false;
            return '/app/home';
          }

          return null;
        },
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) {
              final denied = state.uri.queryParameters['denied'] == 'true';
              return LoginScreen(showAccessDenied: denied);
            },
          ),
          GoRoute(
            path: '/app/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/app/allocationPdf',
            builder: (context, state) => const AllocationPdfPreview(),
          ),
          GoRoute(
            path: '/app/searchAttendance',
            builder: (context, state) => const SearchAttendanceScreen(),
          ),
          GoRoute(
            path: '/app/attendancePdf',
            builder: (context, state) => const AttendancePdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/employeePdf',
            builder: (context, state) => const EmployeePdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/expensePdf',
            builder: (context, state) => const ExpensesPdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/searchExpense',
            builder: (context, state) => const SearchExpenseScreen(),
          ),
          GoRoute(
            path: '/app/otherExpensePdf',
            builder: (context, state) => const OtherExpensesPdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/otherExpense',
            builder: (context, state) => const OtherExpensesScreen(),
          ),
          GoRoute(
            path: '/app/membershipPdf',
            builder: (context, state) => const MemberPdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/adminPage',
            builder: (context, state) => const AdminProfileScreen(),
          ),
          GoRoute(
            path: '/app/tablePdf',
            builder: (context, state) => const TablePdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/reportsAndSales',
            builder: (context, state) => const ReportsAndSaleTableWise(),
          ),
          GoRoute(
            path: '/app/salesPdfPreviewPages',
            builder: (context, state) => const SalesPdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/searchSalaryScreen',
            builder: (context, state) => const SearchSalaryScreen(),
          ),
          GoRoute(
            path: '/app/salaryPdf',
            builder: (context, state) => const SalaryPdfPreviewPage(),
          ),
          GoRoute(
            path: '/app/permissionsScreen',
            builder: (context, state) => PermissionsScreen(),
          ),
        ],
      );
}
