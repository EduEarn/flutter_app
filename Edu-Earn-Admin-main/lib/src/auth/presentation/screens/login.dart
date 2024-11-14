import 'package:flutter/material.dart';

import '../../../../shared/responsive/responsive.dart';
import '../desktop/desktop_login.dart';
import '../mobile/mobile_login.dart';
import '../tablet/tablet_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileLoginPage(),
      tablet: TabletLoginPage(),
      desktop: DesktopLoginPage(),
    );
  }
}
