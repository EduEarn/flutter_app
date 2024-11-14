import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:edu_earn_admin/core/job/domain/entity/job.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class JobUpdatePage extends StatefulWidget {
  const JobUpdatePage({super.key, required this.job, required this.fetchCompanyPostedJobs});

  final JobEntity job;
  final Future<void> Function() fetchCompanyPostedJobs;

  @override
  State<JobUpdatePage> createState() => _JobUpdatePageState();
}

class _JobUpdatePageState extends State<JobUpdatePage> {
  ///Controllers
  TextEditingController roleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final typeController = SingleValueDropDownController();
  final levelController = SingleValueDropDownController();

  /// Loading Notifier
  final loading = ValueNotifier<bool>(false);

  List<DropDownValueModel> jobType = JobType.values
      .map((type) {
        return DropDownValueModel(
          name: type.name.contains('partTime')
              ? 'PartTime'
              : type.name.contains('fullTime')
                  ? 'FullTime'
                  : 'Intern',
          value: type,
        );
      })
      .cast<DropDownValueModel>()
      .toList();

  List<DropDownValueModel> educationalLevel = EducationalLevel.values
      .map((level) {
        return DropDownValueModel(name: level.name.contains('student') ? 'Student' : 'Graduate', value: level);
      })
      .cast<DropDownValueModel>()
      .toList();

  @override
  void initState() {
    super.initState();

    roleController.text = widget.job.role;
    amountController.text = widget.job.amount;
    locationController.text = widget.job.location;
    skillController.text = widget.job.skillRequired;
    descriptionController.text = widget.job.description;

    final jobType = JobType.values.firstWhere(
      (e) => e.name.toLowerCase() == widget.job.type.toLowerCase(),
      orElse: () => JobType.values.first,
    );
    typeController.setDropDown(DropDownValueModel(
      name: _capitalizeFirstLetter(jobType.name),
      value: jobType,
    ));

    final educationalLevel = EducationalLevel.values.firstWhere(
      (e) => e.name.toLowerCase() == widget.job.level.toLowerCase(),
      orElse: () => EducationalLevel.values.first,
    );
    levelController.setDropDown(DropDownValueModel(
      name: _capitalizeFirstLetter(educationalLevel.name),
      value: educationalLevel,
    ));
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  void dispose() {
    roleController.dispose();
    amountController.dispose();
    locationController.dispose();
    typeController.dispose();
    levelController.dispose();
    skillController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.width * 0.5,
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.cancel_rounded),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Job Role", style: Theme.of(context).textTheme.bodyLarge))),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      controller: roleController,
                      decoration: const InputDecoration(fillColor: Colors.white, hintText: 'Enter the job role'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Amount', style: Theme.of(context).textTheme.bodyLarge))),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: amountController,
                      decoration:
                          const InputDecoration(fillColor: Colors.white, hintText: 'Enter the amount per month'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Location', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: locationController,
                      decoration: const InputDecoration(fillColor: Colors.white, hintText: 'Enter job location'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropDownTextField(
                          textFieldDecoration: const InputDecoration(fillColor: Colors.white, hintText: 'Job Type'),
                          listTextStyle: Theme.of(context).textTheme.bodyMedium,
                          controller: typeController,
                          clearOption: true,
                          clearIconProperty: IconProperty(color: Colors.blue),
                          dropDownItemCount: jobType.length,
                          dropDownList: jobType,
                          onChanged: (value) {})),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DropDownTextField(
                          textFieldDecoration:
                              const InputDecoration(fillColor: Colors.white, hintText: 'Educational Level'),
                          listTextStyle: Theme.of(context).textTheme.bodyMedium,
                          controller: levelController,
                          clearOption: true,
                          clearIconProperty: IconProperty(color: Colors.blue),
                          dropDownItemCount: educationalLevel.length,
                          dropDownList: educationalLevel,
                          onChanged: (value) {})),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Skill Required', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: skillController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(fillColor: Colors.white, hintText: 'Provide the skill required'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Job Description', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: descriptionController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(fillColor: Colors.white, hintText: 'Provide the job description'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (typeController.dropDownValue != null &&
                              levelController.dropDownValue != null &&
                              roleController.text.isNotEmpty &&
                              amountController.text.isNotEmpty &&
                              locationController.text.isNotEmpty &&
                              skillController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty) {
                            loading.value = true;
                            final companyDetails = await getCompanyDetails(FirebaseAuth.instance.currentUser!.uid);
                            if (companyDetails != null) {
                              final updatedJob = JobEntity(
                                id: widget.job.id,
                                role: roleController.text.trim(),
                                location: locationController.text.trim(),
                                amount: amountController.text.trim(),
                                reviews: widget.job.reviews,
                                companyName: companyDetails['name'],
                                image: companyDetails['image'],
                                aboutCompany: companyDetails['about_company'],
                                companyMission: companyDetails['company_mission'],
                                skillRequired: skillController.text.trim(),
                                description: descriptionController.text.trim(),
                                type: typeController.dropDownValue!.name,
                                level: levelController.dropDownValue!.name,
                                time: DateTime.now(),
                              );

                              await FirebaseFirestore.instance
                                  .collection('jobs')
                                  .doc(widget.job.id)
                                  .update(updatedJob.toMap());
                              widget.fetchCompanyPostedJobs();
                              loading.value = false;
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              setState(() {});
                            } else {
                              debugPrint("Company details not found.");
                              loading.value = false;
                            }
                          }
                        },
                        child: ValueListenableBuilder<bool>(
                          valueListenable: loading,
                          builder: (context, loading, child) {
                            return loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Update Job');
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> getCompanyDetails(String companyId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();

      if (doc.exists) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'image': doc['logo'],
          'company_mission': doc['company_mission'],
          'about_company': doc['about_company'],
        };
      } else {
        debugPrint("No such document!");
        return null;
      }
    } catch (e) {
      debugPrint("Error getting document: $e");
      return null;
    }
  }
}

enum JobType {
  partTime,
  fullTime,
  intern,
}

enum EducationalLevel {
  student,
  graduate,
}
