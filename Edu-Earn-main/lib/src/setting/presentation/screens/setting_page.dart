import 'package:edu_earn/src/authentication/presentation/screens/auth_page.dart';
import 'package:edu_earn/src/setting/presentation/screens/personal_details.dart';
import 'package:edu_earn/src/setting/presentation/screens/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:wiredash/wiredash.dart';

import '../../../../core/user/domain/entity/user.dart';
import '../../../../shared/data/image_assets.dart';
import '../../../../shared/theme/theme_bloc.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final user = ValueNotifier<UserEntity>(UserEntity.initial());

  @override
  void initState() {
    context.read<AuthBloc>().add(GetUserInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserInfoLoaded) {
          user.value = state.user;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFFFE28D),
                foregroundImage: AssetImage(ImageAssets.profile),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  height: 180,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Customize Your\nExperience",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Text("With personal details,notifications,\nprivacy language and support setting",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300)),
                        ],
                      ),
                      SizedBox(
                        width: 100,
                        child: Image.asset(ImageAssets.setting, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                            width: double.infinity,
                            height: 150,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade900
                                  : const Color(0xfff8f8f8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => PersonalDetails(user: user.value));
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text('Edit your personal details'), Icon(Icons.chevron_right)],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider()
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // Get.to(() => UpdateProfilePage(user: user.value));
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text('Update profile picture'), Icon(Icons.chevron_right)],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider()
                                  ],
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Support & Feedback',
                        style:
                            Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Container(
                            width: double.infinity,
                            height: 150,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade900
                                  : const Color(0xfff8f8f8),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Wiredash.of(context).show(inheritMaterialTheme: true);
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text('Contact customer support'), Icon(Icons.chevron_right)],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider()
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Wiredash.of(context).show(inheritMaterialTheme: true);
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text('Provide feedback'), Icon(Icons.chevron_right)],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider()
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Add switch here to toggle the theme mode
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : const Color(0xfff8f8f8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark Mode',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Switch.adaptive(
                          value: context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            context.read<ThemeBloc>().add(ToggleThemeEvent());
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: const Text("Logout"),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
