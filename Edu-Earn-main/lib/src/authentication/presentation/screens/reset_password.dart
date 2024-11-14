import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:edu_earn/src/authentication/presentation/widgets/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../shared/utils/snackbar.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot Password",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    ),
              ),
              const SizedBox(height: 15),
              Text(
                "Please enter your email account to reset password.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(ImageAssets.reset),
                  const SizedBox(height: 15),
                  Text(
                    "Email",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                  ),
                  InputField(
                    controller: emailController,
                    placeholder: "Enter your email",
                    obscureText: false,
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (emailController.text.isEmpty) {
                            return;
                          }
                          await resetPassword();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          "Submit",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                              ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> resetPassword() async {
    context.loaderOverlay.show();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      if (!mounted) {
        return;
      }
      context.loaderOverlay.hide();
      CustomSnackBar.showSnackBar(
        context: context,
        title: "Password Reset Email Sent",
        message: "Please check your email for instructions on resetting your password.",
        contentType: ContentType.success,
      );

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (err) {
      debugPrint(err.toString());
      if (mounted) context.loaderOverlay.hide();
    }
  }
}
