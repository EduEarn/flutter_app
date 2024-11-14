import 'package:edu_earn_admin/src/auth/presentation/mobile/mobile_company_info.dart';
import 'package:flutter/material.dart';

import '../desktop/desktop_company_info.dart';

import '../../../../shared/responsive/responsive.dart';
import '../tablet/tablet_company_info.dart';

class CompanyInfoPage extends StatefulWidget {
  const CompanyInfoPage({super.key});

  @override
  State<CompanyInfoPage> createState() => _CompanyInfoPageState();
}

class _CompanyInfoPageState extends State<CompanyInfoPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileCompanyInfoPage(),
      tablet: TabletCompanyInfoPage(),
      desktop: DesktopCompanyInfoPage(),
    );
  }
}
