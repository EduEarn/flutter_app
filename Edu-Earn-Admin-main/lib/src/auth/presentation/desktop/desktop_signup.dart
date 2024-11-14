import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../core/company/entity/company.dart';
import '../bloc/auth_bloc.dart';
import '../screens/company_info_page.dart';
import '../widgets/input_field.dart';

class DesktopRegisterPage extends StatefulWidget {
  const DesktopRegisterPage({super.key});

  @override
  State<DesktopRegisterPage> createState() => _DesktopRegisterPageState();
}

class _DesktopRegisterPageState extends State<DesktopRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            context.loaderOverlay.hide();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  surfaceTintColor: Colors.redAccent,
                  shape: const RoundedRectangleBorder(),
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          if (state is GoogleAuthSuccess) {
            context.loaderOverlay.hide();
            if (state.userCred.additionalUserInfo!.isNewUser) {
              // Navigator.pushAndRemoveUntil(
              //     context, MaterialPageRoute(builder: (context) => const CompanyInfoPage()), (route) => false);
            } else {
              // Navigator.pushAndRemoveUntil(
              //     context, MaterialPageRoute(builder: (context) => const CompanyInfoPage()), (route) => false);
            }
          }
          if (state is AuthSuccess) {
            context.loaderOverlay.hide();
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => const CompanyInfoPage()), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            context.loaderOverlay.show();
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Create An account",
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
                    SizedBox(
                      width: 400,
                      height: 45,
                      child: OutlinedButton(
                        onPressed: () {},
                        // onPressed: () => context.read<AuthBloc>().add(ContinueWithGoogle()),
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/img/Google.png"),
                            const SizedBox(width: 8),
                            Text('Google', style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35.0, left: 70, right: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'or sign up with',
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Company Name"),
                              SizedBox(
                                width: 400,
                                height: 55,
                                child: InputField(
                                  controller: nameController,
                                  placeholder: 'Enter your company name',
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Email"),
                              SizedBox(
                                width: 400,
                                height: 55,
                                child: InputField(
                                  controller: emailController,
                                  placeholder: 'Enter your company email',
                                  obscureText: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Password"),
                              SizedBox(
                                width: 400,
                                height: 55,
                                child: InputField(
                                  controller: passwordController,
                                  placeholder: 'Enter your password',
                                  obscureText: true,
                                ),
                              ),
                            ],
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
                          const SizedBox(height: 16.0),
                          SizedBox(
                            width: 400,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                if (emailController.text.isEmpty ||
                                    passwordController.text.isEmpty ||
                                    nameController.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        surfaceTintColor: Colors.redAccent,
                                        shape: const RoundedRectangleBorder(),
                                        title: const Text('Form Incomplete'),
                                        content: const Text('Please fill in all required fields.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                }
                                context.read<AuthBloc>().add(AuthSignUp(
                                  company: Company(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    logo: "",
                                  ),
                                ));
                              },
                              style: ElevatedButton.styleFrom(elevation: 0),
                              child: const Text('Register'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?  ", textAlign: TextAlign.center),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/auth.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}