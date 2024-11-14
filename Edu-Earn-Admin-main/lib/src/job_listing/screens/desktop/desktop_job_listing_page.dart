import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn_admin/src/job_listing/screens/desktop/job_update_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/job/domain/entity/job.dart';

class DesktopJobListingPage extends StatefulWidget {
  const DesktopJobListingPage({super.key});

  @override
  State<DesktopJobListingPage> createState() => _DesktopJobListingPageState();
}

class _DesktopJobListingPageState extends State<DesktopJobListingPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  List<JobEntity> companyPostedJobs = [];

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

  Future<void> fetchCompanyPostedJobs() async {
    String companyName = await fetchCompanyName();

    final querySnapshot =
    await FirebaseFirestore.instance.collection('jobs').where('company', isEqualTo: companyName).get();

    final postedJobs = querySnapshot.docs.map((doc) {
      final data = doc.data();
      final job = JobEntity.fromMap(data);
      return job;
    }).toList();
    setState(() {
      companyPostedJobs = postedJobs;
    });
  }

  @override
  void initState() {
    fetchCompanyPostedJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                                DataColumn(label: Text('Role')),
                                DataColumn(label: Text('Type')),
                                DataColumn(label: Text('Educational Level')),
                                DataColumn(label: Text('Location')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: companyPostedJobs.map((jobs) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(jobs.role)),
                                    DataCell(Text(jobs.type)),
                                    DataCell(Text(jobs.level)),
                                    DataCell(Text(jobs.location)),
                                    DataCell(Text(jobs.amount)),
                                    DataCell(Text(DateFormat('MMMM d, yyyy').format(jobs.time))),
                                    DataCell(
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_horiz, color: Color(0xFF6A3993)),
                                        color: Colors.white,
                                        onSelected: (String result) {
                                          switch (result) {
                                            case 'edit':
                                            // Implement edit functionality
                                              _editJob(jobs);
                                              break;
                                            case 'delete':
                                            // Implement delete functionality
                                              _deleteJob(jobs);
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<String>>[
                                          const PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          const PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ],
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

  void _editJob(JobEntity job) {
    showDialog(
      context: context,
      builder: (context) =>
          JobUpdatePage(
            job: job,
            fetchCompanyPostedJobs: fetchCompanyPostedJobs,
          ),
    );
  }

  void _deleteJob(JobEntity job) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                FirebaseFirestore.instance.collection('jobs').doc(job.id).delete();
                fetchCompanyPostedJobs();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
