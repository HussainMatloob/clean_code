import 'package:flutter/material.dart';
import 'package:snooker_management/constants/images_constant.dart';
import 'package:snooker_management/views/widgets/Features_chip_widget.dart';

class BrandPanelView extends StatelessWidget {
  final Color gold;
  final Color green;
  const BrandPanelView({
    super.key,
    required this.gold,
    required this.green,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            SizedBox(
              height: 84,
              child: Image.asset(
                ImageConstant.logo, // <— replace with your logo or remove
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              "Snooker Partner",
              textAlign: TextAlign.center,
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: gold,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),

            // Tagline
            Text(
              "Precision • Performance • Play",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 22),

            // Description (rich + professional)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                "Welcome to Snooker Partner — the complete management system for your snooker club. "
                "Manage table allocations with live game tracking, handle memberships and billing, track employee "
                "attendance and salaries, monitor sales and expenses, and generate profit & loss reports. "
                "All with role-based access for smooth, professional operations.",
                textAlign: TextAlign.start,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 26),

            // Feature list
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  FeatureChipWidget(
                    icon: Icons.event_available,
                    label: "Table Allocations",
                  ),
                  FeatureChipWidget(
                    icon: Icons.sports_score,
                    label: "Live Game Tracking",
                  ),
                  FeatureChipWidget(
                    icon: Icons.people_alt_outlined,
                    label: "Player & Membership Management",
                  ),
                  FeatureChipWidget(
                    icon: Icons.badge_outlined,
                    label: "Employee Attendance & Salaries",
                  ),
                  FeatureChipWidget(
                    icon: Icons.attach_money,
                    label: "Sales & Expenses Tracking",
                  ),
                  FeatureChipWidget(
                    icon: Icons.bar_chart_outlined,
                    label: "Profit & Loss Reports",
                  ),
                  FeatureChipWidget(
                    icon: Icons.security_outlined,
                    label: "Role-based Access",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
