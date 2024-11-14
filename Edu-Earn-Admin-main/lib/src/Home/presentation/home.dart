import 'package:edu_earn_admin/src/Home/presentation/screens/main_page.dart';
import 'package:edu_earn_admin/src/job_listing/job_listing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/responsive/responsive.dart';
import '../../../shared/widgets/side_menu.dart';
import '../../applications/applications_page.dart';
import '../bloc/menu_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _pages = [
    const Dashboard(),
    const ApplicationPage(),
    const JobListingPage(),
  ];

  void changeActiveIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: context.watch<MenuBloc>().state.scaffoldKey,
        drawer: SideMenu(
          onButtonPressed: changeActiveIndex,
        ),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context)) Expanded(child: SideMenu(onButtonPressed: changeActiveIndex)),
              Expanded(flex: 5, child: IndexedStack(index: _selectedIndex, children: _pages))
            ],
          ),
        ));
  }
}
