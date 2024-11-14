import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../shared/utils/snackbar.dart';
import '../../../home/presentation/screens/main_page.dart';

class JobSelectPage extends StatefulWidget {
  const JobSelectPage({Key? key}) : super(key: key);

  @override
  State<JobSelectPage> createState() => _JobSelectPageState();
}

class _JobSelectPageState extends State<JobSelectPage> {
  List<String> jobs = [];
  List<String> availableJobs = [
    'Mobile Developer',
    'Web Developer',
    'UI/UX Designer',
    'Data Analyst',
    'Software Engineer',
    'Graphic Designer',
    'Product Manager',
    'Content Writer',
    'Marketing Specialist',
    'IT Consultant',
    'Financial Analyst',
    'HR Manager',
    'Project Manager',
    'Business Analyst',
    'Sales Representative',
    'Operations Manager',
    'QA Engineer',
    'Network Engineer',
    'Customer Support Specialist',
    'Database Administrator',
    'System Administrator',
    'Technical Writer',
    'Security Analyst',
    'Game Developer',
    'DevOps Engineer',
    'Data Scientist',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign up to find work you love",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Add job roles for better search.",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: availableJobs.map((job) {
                          return ChoiceChip(
                            label: Text(job),
                            selected: jobs.contains(job),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  jobs.add(job);
                                } else {
                                  jobs.remove(job);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: () async {
                    if (jobs.isEmpty) {
                      return CustomSnackBar.showSnackBar(
                        context: context,
                        title: "No Jobs Added",
                        message: "Please add at least one job role.",
                        contentType: ContentType.warning,
                      );
                    }
                    context.loaderOverlay.show();
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      try {
                        await FirebaseFirestore.instance.collection("users").doc(user.uid).update(
                          {'job': jobs},
                        );
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
                        context.loaderOverlay.hide();
                      } catch (e) {
                        context.loaderOverlay.hide();
                        CustomSnackBar.showSnackBar(
                          context: context,
                          title: "Error",
                          message: "Error updating jobs",
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
      ),
    );
  }
}
