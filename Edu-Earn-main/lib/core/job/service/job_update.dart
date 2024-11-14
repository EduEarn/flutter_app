import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';

import '../../../src/notification/service/notification.dart';

class JobUpdateService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userId;

  JobUpdateService({required this.userId});

  void startListening() {
    firestore.collection('jobs').snapshots().listen((snapshot) {
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.modified) {
          _checkAndNotify(change.doc);
        }
      }
    });
  }

  Future<void> _checkAndNotify(DocumentSnapshot jobDoc) async {
    final applicationQuery = await firestore
        .collection('job_applications')
        .where('jobId', isEqualTo: jobDoc.id)
        .where('userId', isEqualTo: userId)
        .get();
    if (applicationQuery.docs.isNotEmpty) {
      final job = JobEntity.fromMap(jobDoc.data() as Map<String, dynamic>);
      NotificationService.showInstantNotification(
        1,
        'Job Update',
        'The role "${job.role}" at ${job.companyName} has been updated.',
        payload: jobDoc.id,
      );
    }
  }
}
