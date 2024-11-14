import 'package:edu_earn_admin/src/applications/screens/desktop/desktop_application_page.dart';
import 'package:edu_earn_admin/src/applications/screens/mobile/mobile_application_page.dart';
import 'package:edu_earn_admin/src/applications/screens/tablet/tablet_application_page.dart';
import 'package:edu_earn_admin/src/job_listing/screens/desktop/desktop_job_listing_page.dart';
import 'package:edu_earn_admin/src/job_listing/screens/mobile/mobile_job_listing_page.dart';
import 'package:edu_earn_admin/src/job_listing/screens/tablet/tablet_job_listing_page.dart';
import 'package:flutter/material.dart';

import '../../shared/responsive/responsive.dart';

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileJobListingPage(),
      tablet: TabletJobListingPage(),
      desktop: DesktopJobListingPage(),
    );
  }
}
