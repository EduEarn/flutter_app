import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:edu_earn/src/authentication/presentation/bloc/auth_bloc.dart';
import 'package:edu_earn/src/authentication/presentation/screens/login.dart';
import 'package:edu_earn/src/authentication/presentation/screens/personal_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../shared/utils/snackbar.dart';
import '../../../home/presentation/screens/main_page.dart';
import '../widgets/input_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool isSwitched = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    fullNameController.dispose();
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
                  context.loaderOverlay.hide();
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => const PersonalInfoPage()), (route) => false);
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
                      "Sign up to find work you love",
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                          ),
                    ),
                    const SizedBox(height: 20),
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
                      padding: const EdgeInsets.only(top: 30.0),
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
                                "Fullname",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                              ),
                              InputField(
                                controller: fullNameController,
                                placeholder: 'Enter name',
                                obscureText: false,
                                icon: Icons.email_outlined,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Name is required';
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
                          const SizedBox(height: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone Number",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                              ),
                              InputField(
                                controller: phoneController,
                                placeholder: 'Enter Phone Number',
                                obscureText: false,
                                icon: Icons.phone,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
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
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() => _passwordVisible = !_passwordVisible);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                //Handle signUp
                                context.read<AuthBloc>().add(
                                      AuthSignUp(
                                        user: UserEntity(
                                          fullName: fullNameController.text.trim(),
                                          email: emailController.text.trim(),
                                          password: passwordController.text.trim(),
                                          phoneNumber: phoneController.text.trim(),
                                          school: "",
                                          educationLevel: "",
                                          workPreference: "",
                                          location: "",
                                          image: "",
                                          job: const [],
                                        ),
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                fixedSize: const Size(double.infinity, 69),
                              ),
                              child: Text(
                                "Next",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                    ),
                              ),
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
            const Text("Already  have an account?", textAlign: TextAlign.center),
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
              },
              child: Text(
                " Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
