import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/src/home/presentation/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../core/user/domain/entity/user.dart';
import '../../../../shared/data/image_assets.dart';
import '../../../../shared/utils/snackbar.dart';
import '../../../authentication/presentation/widgets/input_field.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key, required this.user});

  final UserEntity user;

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> educationLevel = ['Student', 'Graduate'];
  List<String> workPreference = ['PartTime', 'FullTime', 'Intern'];
  List<String> school = ['KNUST', 'UG', 'UCC', 'WINEBA'];

  String selectedSchool = '';
  String selectedWorkPreference = '';
  String selectedEducationLevel = '';

  @override
  void initState() {
    fullNameController.text = widget.user.fullName;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phoneNumber;
    selectedWorkPreference = widget.user.workPreference;
    selectedEducationLevel = widget.user.educationLevel;
    selectedSchool = widget.user.school;
    locationController.text = widget.user.location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
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
                      width: 80,
                      child: Image.asset(ImageAssets.person, fit: BoxFit.cover),
                    ),
                  ],
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
                          "Full name",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                        ),
                        InputField(
                          controller: fullNameController,
                          placeholder: 'Enter full name',
                          obscureText: false,
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
                          "Phone Number",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400)
                        ),
                        InputField(
                          controller: phoneController,
                          placeholder: 'Enter your phone number',
                          obscureText: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone number is required';
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
                    const SizedBox(height: 50)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          context.loaderOverlay.show();
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            Map<String, dynamic> updatedInfo = {
              'fullName': fullNameController.text.trim(),
              'phoneNumber': phoneController.text.trim(),
              'school': selectedSchool,
              'educationLevel': selectedEducationLevel,
              'workPreference': selectedWorkPreference,
              'location': locationController.text,
            };
            try {
              await FirebaseFirestore.instance.collection("users").doc(user.uid).update(updatedInfo);
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => const MainPage()), (route) => false);
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
        label: Text(
          "Save",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
