import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_earn/core/job/domain/entity/job.dart';

class JobApplication {
  final String userId;
  final String jobId;
  final JobEntity job;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String cvUrl;
  final DateTime createdAt;
  final String? coverLetter;

  JobApplication({
    required this.userId,
    required this.jobId,
    required this.job,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.cvUrl,
    required this.createdAt,
    this.coverLetter,
  });

  factory JobApplication.initial() {
    return JobApplication(
      userId: '',
      jobId: '',
      job: JobEntity.initial(),
      fullName: '',
      email: '',
      phoneNumber: '',
      cvUrl: '',
      createdAt: DateTime.now(),
      coverLetter: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'jobId': jobId,
      'job': job.toMap(),
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'cvUrl': cvUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'coverLetter': coverLetter,
    };
  }

  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      userId: map['userId'],
      jobId: map['jobId'],
      job: JobEntity.fromMap(map['job']),
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      cvUrl: map['cvUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      coverLetter: map['coverLetter'],
    );
  }

  JobApplication copyWith({
    String? userId,
    String? jobId,
    JobEntity? job,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? cvUrl,
    DateTime? createdAt,
    String? coverLetter,
  }) {
    return JobApplication(
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      job: job ?? this.job,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cvUrl: cvUrl ?? this.cvUrl,
      createdAt: createdAt ?? this.createdAt,
      coverLetter: coverLetter ?? this.coverLetter,
    );
  }
}
