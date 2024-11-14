import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/job_application.dart';

abstract class JobApplicationRemoteDatabase {
  Future<JobApplication> applyForJob(JobApplication jobApplication);

  Future<List<JobApplication>> fetchApplications(String userId);
}

class JobApplicationRemoteDatabaseImpl implements JobApplicationRemoteDatabase {
  @override
  Future<JobApplication> applyForJob(JobApplication jobApplication) async {
    await FirebaseFirestore.instance.collection('job_applications').add(jobApplication.toMap());
    return jobApplication;
  }

  @override
  Future<List<JobApplication>> fetchApplications(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('job_applications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    final List<JobApplication> applications =
        querySnapshot.docs.map((doc) => JobApplication.fromMap(doc.data())).toList();
    return applications;
  }
}
