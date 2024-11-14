import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn_admin/shared/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/applications/domain/entity/job_application.dart';
import '../../../../core/job/domain/entity/job.dart';
import 'dart:js' as js;

class DesktopApplicationPage extends StatefulWidget {
  const DesktopApplicationPage({super.key});

  @override
  State<DesktopApplicationPage> createState() => _DesktopApplicationPageState();
}

class _DesktopApplicationPageState extends State<DesktopApplicationPage> {
  List<JobApplication> companyApplications = [];
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    fetchCompanyApplications();
    super.initState();
  }

  Future<String> fetchCompanyName() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('companies').doc(currentUser!.uid).get();
        if (doc.exists) {
          final name = doc['name'] as String;
          return name;
        }
      } catch (e) {
        debugPrint("Error getting document: $e");
        return '';
      }
    }
    return '';
  }

  Future<void> fetchCompanyApplications() async {
    String companyName = await fetchCompanyName();

    final querySnapshot = await FirebaseFirestore.instance
        .collection('job_applications')
        .where('job.company', isEqualTo: companyName)
        .get();

    final applications = querySnapshot.docs.map((doc) {
      final data = doc.data();
      final jobData = data['job'] as Map<String, dynamic>;
      final job = JobEntity.fromMap(jobData);

      return JobApplication(
        userId: data['userId'],
        jobId: data['jobId'],
        job: job,
        fullName: data['fullName'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        cvUrl: data['cvUrl'],
        createdAt: data['createdAt'].toDate(),
        coverLetter: data['coverLetter'],
      );
    }).toList();
    setState(() {
      companyApplications = applications;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Header(headerTitle: "Applications List"),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Card(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minWidth: constraints.maxWidth),
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              dividerThickness: 0.2,
                              columns: const <DataColumn>[
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Phone Number')),
                                DataColumn(label: Text('Role')),
                                DataColumn(label: Text('Educational Level')),
                                DataColumn(label: Text('CV')),
                              ],
                              rows: companyApplications.map((application) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(application.fullName)),
                                    DataCell(Text(application.email)),
                                    DataCell(Text(application.phoneNumber)),
                                    DataCell(Text(application.job.role)),
                                    DataCell(Text(application.job.level)),
                                    DataCell(
                                      InkWell(
                                        onTap: () {
                                          js.context.callMethod('open', [application.cvUrl]);
                                        },
                                        borderRadius: BorderRadius.circular(8),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'View CV',
                                            style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
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
