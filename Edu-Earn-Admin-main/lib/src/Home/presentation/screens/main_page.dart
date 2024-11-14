import 'package:edu_earn_admin/src/Home/presentation/screens/tablet/tablet_dashboard.dart';
import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive.dart';
import 'desktop/desktop_dashboard.dart';
import 'mobile/mobile_dashboard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileDashboard(),
      tablet: TabletDashboard(),
      desktop: DesktopDashboard(),
    );
  }
}
