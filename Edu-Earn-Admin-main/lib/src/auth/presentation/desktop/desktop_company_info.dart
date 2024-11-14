import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../Home/presentation/home.dart';
import '../widgets/input_field.dart';

class DesktopCompanyInfoPage extends StatefulWidget {
  const DesktopCompanyInfoPage({super.key});

  @override
  State<DesktopCompanyInfoPage> createState() => _DesktopCompanyInfoPageState();
}

class _DesktopCompanyInfoPageState extends State<DesktopCompanyInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController missionController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  Uint8List? companyLogo;

  @override
  void dispose() {
    missionController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePickerPlugin imagePicker = ImagePickerPlugin();
    final pickedFile = await imagePicker.getImageFromSource(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        companyLogo = imageBytes;
      });
    }
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw FirebaseAuthException(code: 'no-user', message: 'User is not logged in');

    final storageRef = FirebaseStorage.instance.ref().child('company_logos').child('${user.uid}.png');
    final uploadTask = storageRef.putData(imageBytes);

    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please Provide the following Details\n about your company",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text("Enter your information below.", style: Theme.of(context).textTheme.bodyMedium),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      // Company's image
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            shape: BoxShape.circle,
                            image: companyLogo != null
                                ? DecorationImage(
                              image: MemoryImage(companyLogo!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: companyLogo == null
                              ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                            size: 50,
                          )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input for company's mission
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Company Mission'),
                          SizedBox(
                            width: 500,
                            height: 120,
                            child: InputField(
                              controller: missionController,
                              placeholder: 'Please enter the company\'s mission',
                              obscureText: false,
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Input for about_company
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("About the Company"),
                          SizedBox(
                            width: 500,
                            height: 120,
                            child: InputField(
                              controller: aboutController,
                              placeholder: 'Please enter details about the company',
                              obscureText: false,
                              maxLines: 4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),

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
                        width: 500,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () async {
                            context.loaderOverlay.show();
                            if (missionController.text.isEmpty || aboutController.text.isEmpty || companyLogo == null) {
                              context.loaderOverlay.hide();
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
                            User? user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              try {
                                final logoUrl = await uploadImage(companyLogo!);
                                Map<String, dynamic> additionalInfo = {
                                  'company_mission': missionController.text.trim(),
                                  'about_company': aboutController.text.trim(),
                                  'logo': logoUrl
                                };
                                await FirebaseFirestore.instance
                                    .collection("companies")
                                    .doc(user.uid)
                                    .update(additionalInfo);
                                if (!context.mounted) return;
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => const HomePage()));
                                context.loaderOverlay.hide();
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            } else {
                              context.loaderOverlay.hide();
                              debugPrint("User not found");
                            }
                          },
                          style: ElevatedButton.styleFrom(elevation: 0),
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
      ),
    );
  }
}