// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:edu_earn/src/authentication/presentation/screens/auth_page.dart';
import 'package:edu_earn/src/onboarding/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../widgets/onboarding_item_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int activePage = 0;
  double currentPageValue = 0.0;
  final PageController _pageController = PageController();

  List<OnBoardingItem> onBoardingItems = [
    OnBoardingItem(
      headline: "Welcome to EduEarn",
      subTitle:
          "Find your internships and entry level job for student and recent graduate. Also build your resume with our generator.",
      image: ImageAssets.onboard1,
    ),
    OnBoardingItem(
      headline: "Find your next job or internship",
      subTitle: "We will help you find the best opportunities",
      image: ImageAssets.onboard2,
    ),
    OnBoardingItem(
      headline: "Find great work",
      subTitle: "Meet clients you're",
      image: ImageAssets.onboard3,
    ),
  ];

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isLastPage = activePage == onBoardingItems.length - 1;
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                physics: const BouncingScrollPhysics(),
                onPageChanged: (value) {
                  setState(() {
                    activePage = value;
                  });
                },
                controller: _pageController,
                itemCount: onBoardingItems.length,
                itemBuilder: (context, index) {
                  final item = onBoardingItems[index];
                  Alignment alignment = Alignment.center;
                  if (index == currentPageValue.floor()) {
                    alignment = Alignment.centerLeft;
                  } else if (index == currentPageValue.floor() + 1) {
                    alignment = Alignment.centerRight;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(currentPageValue - index)
                          ..scale(1 - (currentPageValue - index).abs()),
                        alignment: alignment,
                        child: OnBoardingItemPage(
                          item: item,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardingItems.length,
                      (index) {
                        return AnimatedContainer(
                          height: 6,
                          margin: const EdgeInsets.only(right: 5.0),
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: activePage == index ? Theme.of(context).colorScheme.primary : Colors.grey,
                          ),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onSubmit: (controller,){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                    },
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

class OnBoardingItem {
  final String headline;
  final String subTitle;
  final String image;

  OnBoardingItem({
    required this.headline,
    required this.subTitle,
    required this.image,
  });
}
