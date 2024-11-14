import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String userId;
  final String jobId;

  const Bookmark({
    required this.userId,
    required this.jobId,
  });

  @override
  List<Object?> get props => [userId, jobId];

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      userId: json['userId'] as String,
      jobId: json['jobId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'jobId': jobId,
    };
  }
}
