import 'package:edu_earn/src/applications/presentation/screens/application_list_page.dart';
import 'package:edu_earn/src/home/presentation/screens/home.dart';
import 'package:edu_earn/src/setting/presentation/screens/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../bookmark/presentation/screens/bookmark_page.dart';
import '../../../cv/screens/cv.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  List<Widget> pages = [
    const Home(),
    const JobApplicationListPage(),
    const BookmarkPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: StylishBottomBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_outlined, color: Colors.grey),
            title: const Text(''),
            selectedIcon: const Icon(Icons.home),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          BottomBarItem(
            icon: const Icon(Icons.receipt_outlined, color: Colors.grey),
            title: const Text(''),
            selectedIcon: const Icon(Icons.receipt),
            selectedColor: Theme.of(context).colorScheme.primary,
          ),
          BottomBarItem(
              icon: const Icon(Icons.bookmark_outline, color: Colors.grey),
              title: const Text(''),
              selectedIcon: const Icon(Icons.bookmark),
              selectedColor: Theme.of(context).colorScheme.primary),
          BottomBarItem(
              icon: const Icon(Icons.settings_outlined, color: Colors.grey),
              title: const Text(''),
              selectedIcon: const Icon(Icons.settings),
              selectedColor: Theme.of(context).colorScheme.primary),
        ],
        fabLocation: StylishBarFabLocation.center,
        hasNotch: true,
        option: AnimatedBarOptions(
          iconStyle: IconStyle.Default,
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CVPage());
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.receipt_outlined,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
