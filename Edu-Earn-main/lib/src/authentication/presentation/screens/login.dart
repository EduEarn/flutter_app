import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:edu_earn/shared/utils/snackbar.dart';
import 'package:edu_earn/src/authentication/presentation/screens/personal_info.dart';
import 'package:edu_earn/src/authentication/presentation/screens/reset_password.dart';
import 'package:edu_earn/src/authentication/presentation/screens/sign_up.dart';
import 'package:edu_earn/src/home/presentation/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../bloc/auth_bloc.dart';
import '../widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  context.loaderOverlay.hide();
                  return CustomSnackBar.showSnackBar(
                    context: context,
                    title: "Error",
                    message: state.message,
                    contentType: ContentType.failure,
                  );
                }
                if (state is GoogleAuthSuccess) {
                  context.loaderOverlay.hide();
                  if (state.userCred.additionalUserInfo!.isNewUser) {
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => const PersonalInfoPage()), (route) => false);
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => const MainPage()), (route) => false);
                  }
                }
                if (state is AuthSuccess) {
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => const MainPage()), (route) => false);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  context.loaderOverlay.show();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's get you Login!",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                    ),
                    const SizedBox(height: 15),
                    Text("Enter your information below.", style: Theme.of(context).textTheme.bodyMedium),

                    const SizedBox(height: 40),
                    //Sign in with Google
                    OutlinedButton(
                      onPressed: () => context.read<AuthBloc>().add(ContinueWithGoogle()),
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(double.infinity, 60)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageAssets.google),
                          const SizedBox(width: 8),
                          Text('Google', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'or login with',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          const Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                              ),
                              InputField(
                                controller: emailController,
                                placeholder: 'Enter email',
                                obscureText: false,
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email is required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Password",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                              ),
                              InputField(
                                controller: passwordController,
                                placeholder: 'Enter password',
                                obscureText: _passwordVisible,
                                icon: Icons.lock_outlined,
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => _passwordVisible = !_passwordVisible);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text(
                                    "Forget password?",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.to(() => const ResetPasswordPage());
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                context.read<AuthBloc>().add(AuthLogin(
                                      user: UserEntity(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                        fullName: "",
                                        phoneNumber: "",
                                        school: "",
                                        educationLevel: "",
                                        workPreference: "",
                                        location: "",
                                        image: "",
                                        job: const [],
                                      ),
                                    ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                fixedSize: const Size(double.infinity, 69),
                              ),
                              child: Text(
                                "Login",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                              children: [
                                const TextSpan(
                                  text: "By continuing you agree to our ",
                                ),
                                TextSpan(
                                  text: "Terms of Service",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const TextSpan(text: " and "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account yet?", textAlign: TextAlign.center),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const SignUpPage()), (route) => false);
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
