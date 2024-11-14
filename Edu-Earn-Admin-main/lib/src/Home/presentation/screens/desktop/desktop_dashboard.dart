import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/applications/domain/entity/job_application.dart';
import '../../../../../core/job/domain/entity/job.dart';
import '../../../../../shared/widgets/custom_card.dart';
import '../../../../../shared/widgets/header.dart';
import 'job_post_page.dart';
import 'dart:js' as js;

class DesktopDashboard extends StatefulWidget {
  const DesktopDashboard({super.key});

  @override
  State<DesktopDashboard> createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard> {
  List<JobApplication> companyApplications = [];
  final currentUser = FirebaseAuth.instance.currentUser;
  late int jobsPosted = 0;

  @override
  void initState() {
    fetchCompanyApplications();
    fetchCompanyPostedJobs();
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

  Future<void> fetchCompanyPostedJobs() async {
    String companyName = await fetchCompanyName();

    final querySnapshot =
    await FirebaseFirestore.instance.collection('jobs').where('company', isEqualTo: companyName).get();
    final jobs = querySnapshot.docs;
    setState(() {
      jobsPosted = jobs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Header(headerTitle: 'Dashboard'),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  childAspectRatio: 3 / 1.2,
                  children: [
                    CustomCard(
                      color: const Color(0xff1EAD96),
                      icon: Icons.remove_red_eye,
                      number: companyApplications.length.toString(),
                      title: 'Total Applications',
                      bgColor: const Color(0xffE2F6F4),
                    ),
                    const CustomCard(
                      color: Colors.red,
                      icon: Icons.border_inner,
                      number: "1",
                      title: 'Accepted',
                      bgColor: Color(0xffFDE7EB),
                    ),
                    CustomCard(
                      color: const Color(0xff1EAD96),
                      icon: Icons.rate_review,
                      number: jobsPosted.toString(),
                      title: 'Job Posts',
                      bgColor: const Color(0xffE2F6F4),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const JobPostPage(),
          );
        },
        label: const Text("Post Job"),
      ),
    );
  }
}
