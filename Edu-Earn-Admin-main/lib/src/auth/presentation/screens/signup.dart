import 'package:flutter/material.dart';

import '../desktop/desktop_signup.dart';

import '../../../../shared/responsive/responsive.dart';
import '../mobile/mobile_signup.dart';
import '../tablet/tablet_signup.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileRegisterPage(),
      tablet: TabletRegisterPage(),
      desktop: DesktopRegisterPage(),
    );
  }
}
