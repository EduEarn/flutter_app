import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.obscureText,
    this.icon,
    this.validator,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(19),
    this.suffixIcon,
    this.focusNode,
    this.initialValue,
    this.onChanged,
    this.enabled,
    this.prefixIcon,
    this.onEditingComplete,
    this.keyboardType,
    this.fillColor,
    this.filled
  });

  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final IconData? icon;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final void Function(String)? onFieldSubmitted;
  final String? initialValue;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final bool? enabled;
  final void Function()? onEditingComplete;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        initialValue: initialValue,
        obscureText: obscureText,
        validator: validator,
        maxLines: maxLines,
        enabled: enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        textInputAction: TextInputAction.done,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          fillColor: fillColor,
          filled: filled,
          border: Theme.of(context).inputDecorationTheme.border,
          focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
          enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
          errorBorder: Theme.of(context).inputDecorationTheme.errorBorder,
          focusedErrorBorder: Theme.of(context).inputDecorationTheme.focusedErrorBorder,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
