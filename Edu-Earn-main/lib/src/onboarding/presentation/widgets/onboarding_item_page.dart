// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../screens/onboarding_page.dart';

class OnBoardingItemPage extends StatelessWidget {
  const OnBoardingItemPage({
    Key? key,
    required this.item,
  }) : super(key: key);
  final OnBoardingItem item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(item.image),
        const SizedBox(height: 14),
        Text(
          item.headline,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 14),
        Text(
          item.subTitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

      ],
    );
  }
}
