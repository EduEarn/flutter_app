import 'package:edu_earn/shared/data/image_assets.dart';
import 'package:edu_earn/src/authentication/presentation/screens/login.dart';
import 'package:edu_earn/src/authentication/presentation/screens/sign_up.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImageAssets.onboard4),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.white,
                  borderRadius: BorderRadius.circular(42),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your Dream Job\n is waiting for you.',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Find interesting vacancies from\n trusted companies.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                            ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                            },
                            child: Container(
                              width: 130,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            },
                            child: Container(
                              width: 130,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
