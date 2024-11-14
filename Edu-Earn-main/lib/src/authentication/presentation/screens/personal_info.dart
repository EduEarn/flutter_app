import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/shared/utils/snackbar.dart';
import 'package:edu_earn/src/applications/presentation/screens/job_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../widgets/input_field.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController locationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEmailChecked = false;
  bool isPrivacyChecked = false;

  List<String> school = ['KNUST', 'UG', 'UCC', 'WINEBA'];
  List<String> educationLevel = ['Student', 'Graduate'];

  String selectedSchool = 'KNUST';

  List<String> workPreference = ['PartTime', 'FullTime', 'Intern'];

  String selectedWorkPreference = 'PartTime';
  String selectedEducationLevel = 'Student';

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
                  "Sign up to find work you love",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "School",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: DropdownButtonFormField(
                              hint: const Text('Select a school'),
                              value: selectedSchool,
                              isExpanded: true,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() => selectedSchool = newValue!);
                              },
                              items: school.map((school) {
                                return DropdownMenuItem(
                                  value: school,
                                  child: Text(school),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Education Level",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: DropdownButtonFormField(
                              hint: const Text('Education level'),
                              value: selectedEducationLevel,
                              isExpanded: true,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() => selectedEducationLevel = newValue!);
                              },
                              items: educationLevel.map((level) {
                                return DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Work Preference",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: DropdownButtonFormField(
                              hint: const Text('Choose of work'),
                              value: selectedWorkPreference,
                              isExpanded: true,
                              isDense: true,
                              onChanged: (newValue) {
                                setState(() => selectedWorkPreference = newValue!);
                              },
                              items: workPreference.map((preference) {
                                return DropdownMenuItem(
                                  value: preference,
                                  child: Text(preference),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Location",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                          ),
                          InputField(
                            controller: locationController,
                            placeholder: 'Enter your location',
                            obscureText: false,
                            icon: Icons.location_on,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "Send me helpful emails to find rewarding work and jobs leads",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                        ),
                        value: isEmailChecked,
                        side: const BorderSide(color: Colors.grey),
                        onChanged: (newValue) {
                          setState(() {
                            isEmailChecked = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium!,
                            children: const [
                              TextSpan(
                                text: "By continuing you agree to our ",
                              ),
                              TextSpan(
                                text: "Terms of Service",
                                style: TextStyle(
                                  color: Color(0xff8f00ab),
                                ),
                              ),
                              TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Color(0xff8f00ab),
                                ),
                              ),
                            ],
                          ),
                        ),
                        value: isPrivacyChecked,
                        side: const BorderSide(color: Colors.grey),
                        onChanged: (newValue) {
                          setState(() {
                            isPrivacyChecked = newValue!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 65,
                        child: ElevatedButton(
                          onPressed: () async {
                            context.loaderOverlay.show();
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              Map<String, dynamic> additionalInfo = {
                                'school': selectedSchool,
                                'educationLevel': selectedEducationLevel,
                                'workPreference': selectedWorkPreference,
                                'location': locationController.text,
                              };
                              try {
                                await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update(additionalInfo);
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => const JobSelectPage()));
                                context.loaderOverlay.hide();
                              } catch (e) {
                                context.loaderOverlay.hide();
                                CustomSnackBar.showSnackBar(
                                  context: context,
                                  title: "Error",
                                  message: "Error updating additional information",
                                  contentType: ContentType.failure,
                                );
                              }
                            } else {
                              context.loaderOverlay.hide();
                              CustomSnackBar.showSnackBar(
                                context: context,
                                title: "Error",
                                message: "User is not authenticated.",
                                contentType: ContentType.failure,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            "Next",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
