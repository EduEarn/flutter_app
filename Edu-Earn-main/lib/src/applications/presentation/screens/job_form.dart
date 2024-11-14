import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:edu_earn/core/job/domain/entity/job.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/shared/utils/upload_cv.dart';
import 'package:edu_earn/src/applications/domain/entity/job_application.dart';
import 'package:edu_earn/src/applications/presentation/bloc/job_application_bloc.dart';
import 'package:edu_earn/src/home/presentation/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../../shared/data/image_assets.dart';
import '../../../../shared/utils/snackbar.dart';
import '../../../../shared/utils/upload_file.dart';
import '../../../authentication/presentation/widgets/input_field.dart';
import '../../../notification/service/notification.dart';
import '../../../notification/service/repository/notification_repository.dart';

class JobApplicationForm extends StatefulWidget {
  const JobApplicationForm({super.key, required this.user, required this.job});

  final UserEntity user;
  final JobEntity job;

  @override
  State<JobApplicationForm> createState() => _JobApplicationFormState();
}

class _JobApplicationFormState extends State<JobApplicationForm> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final coverController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? cvFile;

  @override
  void initState() {
    fullNameController.text = widget.user.fullName;
    emailController.text = widget.user.email;
    phoneNumberController.text = widget.user.phoneNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JobApplicationBloc, JobApplicationState>(
      listener: (context, state) {
        if (state is JobApplicationLoading) {
          context.loaderOverlay.show();
        }
        if (state is JobApplicationSuccess) {
          context.loaderOverlay.hide();
          CustomSnackBar.showSnackBar(
            context: context,
            title: "Application Submitted",
            message: "Your job application has been successfully submitted. Thank you!",
            contentType: ContentType.success,
          );
          NotificationService.showInstantNotification(
            Random().nextInt(1000000),
            "Thank you for applying to work at ${widget.job.companyName}",
            "Your application was sent to ${widget.job.companyName}",
            payload: jsonEncode({
              'title': "Thank you for applying to work at ${widget.job.companyName}",
              'body': "Your application was sent to ${widget.job.companyName}",
            }),
          );
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainPage()), (route) => false);
        }
        if (state is JobApplicationFailure) {
          context.loaderOverlay.hide();
          return CustomSnackBar.showSnackBar(
            context: context,
            title: "Something went wrong",
            message: "An error occurred submitting application",
            contentType: ContentType.failure,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Application Details',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
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
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "*Fullname",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                      ),
                      InputField(
                        controller: fullNameController,
                        placeholder: 'Fullname',
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Fullname is required';
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
                        "*Email address",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                      ),
                      InputField(
                        controller: emailController,
                        placeholder: 'Email address',
                        obscureText: false,
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
                        "*Phone Number",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                      ),
                      InputField(
                        controller: phoneNumberController,
                        placeholder: 'Phone number',
                        obscureText: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone Number is required';
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
                        "Cover Letter",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                      ),
                      InputField(
                        controller: coverController,
                        placeholder: '',
                        maxLines: 3,
                        obscureText: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "*Upload CV",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(width: 8),
                          Image.asset(ImageAssets.email),
                          const SizedBox(width: 8),
                          if (cvFile != null)
                            Expanded(
                              child: Text(
                                cvFile!.path.split('/').last,
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  contentPadding: EdgeInsets.zero,
                                  content: Container(
                                    width: 384,
                                    height: 175,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey.shade900
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(ImageAssets.upload),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            cvFile = await uploadFile();
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.white
                                                : Theme.of(context).colorScheme.primary,
                                            minimumSize: const Size(250, 45),
                                          ),
                                          child: Text(
                                            'Upload CV',
                                            style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(double.infinity, 60),
                          ),
                          child: Text(
                            'Upload File',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            context.loaderOverlay.show();
            if (!_formKey.currentState!.validate()) {
              context.loaderOverlay.hide();
              return;
            }
            if (cvFile == null) {
              context.loaderOverlay.hide();
              CustomSnackBar.showSnackBar(
                context: context,
                title: "CV required",
                message: "Please upload a CV",
                contentType: ContentType.warning,
              );
              return;
            }
            final cvUrl = await uploadCV(context: context, pickedCv: cvFile!);
            final application = JobApplication(
              userId: FirebaseAuth.instance.currentUser!.uid,
              job: widget.job,
              fullName: fullNameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneNumberController.text.trim(),
              cvUrl: cvUrl,
              coverLetter: coverController.text.trim(),
              createdAt: DateTime.now(),
              jobId: widget.job.id,
            );
            if (context.mounted) {
              context.read<JobApplicationBloc>().add(JobApplied(jobApplication: application));
              context.loaderOverlay.hide();
            }
          },
          label: Text("Apply now",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 16)),
          heroTag: 'btn2',
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 45),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
