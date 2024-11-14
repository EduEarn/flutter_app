import 'package:edu_earn_admin/src/applications/screens/desktop/desktop_application_page.dart';
import 'package:edu_earn_admin/src/applications/screens/mobile/mobile_application_page.dart';
import 'package:edu_earn_admin/src/applications/screens/tablet/tablet_application_page.dart';
import 'package:flutter/material.dart';

import '../../shared/responsive/responsive.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileApplicationPage(),
      tablet: TabletApplicationPage(),
      desktop: DesktopApplicationPage(),
    );
  }
}
