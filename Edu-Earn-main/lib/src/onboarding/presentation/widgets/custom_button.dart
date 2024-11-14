import 'dart:math';

import 'package:flutter/material.dart';
import 'package:action_slider/action_slider.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onSubmit});

  final Function(ActionSliderController)? onSubmit;

  @override
  Widget build(BuildContext context) {
    return ActionSlider.standard(
      sliderBehavior: SliderBehavior.move,
      width: 300.0,
      backgroundColor: Theme.of(context).primaryColor,
      toggleColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.white,
      action: (controller) async {
        controller.loading();
        await Future.delayed(const Duration(seconds: 1));
        controller.success();
        if (onSubmit != null) {
          await Future.delayed(const Duration(seconds: 2));
          await onSubmit!(controller);
        }
        controller.reset();
      },
      // onTap: onSubmit,
      child: const Text(
        'Slide to skip',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
