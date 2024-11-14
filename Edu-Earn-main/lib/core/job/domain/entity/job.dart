import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class JobEntity extends Equatable {
  final String id;
  final String role;
  final String location;
  final String amount;
  final String image;
  final String reviews;
  final String companyName;
  final String aboutCompany;
  final String companyMission;
  final String skillRequired;
  final String description;
  final String type;
  final String level;
  final DateTime time;

  const JobEntity(
      {required this.role,
      required this.id,
      required this.location,
      required this.amount,
      required this.image,
      required this.reviews,
      required this.companyName,
      required this.aboutCompany,
      required this.companyMission,
      required this.skillRequired,
      required this.description,
      required this.type,
      required this.level,
      required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'location': location,
      'amount': amount,
      'company': companyName,
      'reviews': reviews,
      'image': image,
      'description': description,
      'about_company': aboutCompany,
      'skill_required': skillRequired,
      'company_mission': companyMission,
      'type': type,
      'level': level,
      'time': time,
    };
  }

  factory JobEntity.fromMap(Map<String, dynamic> map) {
    Timestamp timestamp = map['time'] as Timestamp;
    return JobEntity(
      id: map['id'] ?? "",
      role: map['role'] ?? "",
      location: map['location'] ?? "",
      amount: map['amount'] ?? "",
      description: map['description'] ?? "",
      image: map['image'] ?? "",
      aboutCompany: map['about_company'] ?? "",
      skillRequired: map['skill_required'] ?? "",
      companyMission: map['company_mission'] ?? "",
      reviews: map['reviews'] ?? "",
      companyName: map['company'] ?? "",
      type: map['type'] ?? "",
      level: map['level'] ?? "",
      time: timestamp.toDate(),
    );
  }

  factory JobEntity.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return JobEntity(
      id: data['id'] ?? '',
      role: data['role'] ?? '',
      location: data['location'] ?? '',
      amount: data['amount'] ?? 0,
      image: data['image'] ?? '',
      reviews: data['reviews'] ?? '',
      companyName: data['company'] ?? '',
      aboutCompany: data['about_company'] ?? '',
      companyMission: data['company_mission'] ?? '',
      skillRequired: data['skill_required'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] ?? '',
      level: data['level'] ?? '',
      time: data['time'] ?? Timestamp.now(),
    );
  }

  factory JobEntity.initial() {
    return JobEntity(
      role: '',
      id: '',
      location: '',
      amount: '',
      image: '',
      reviews: '',
      companyName: '',
      aboutCompany: '',
      companyMission: '',
      skillRequired: '',
      description: '',
      type: '',
      level: '',
      time: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        role,
        location,
        amount,
        image,
        reviews,
        companyName,
        aboutCompany,
        companyMission,
        skillRequired,
        description,
        time,
        type,
        level
      ];
}
