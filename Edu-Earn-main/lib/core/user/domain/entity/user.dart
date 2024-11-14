import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String school;
  final String educationLevel;
  final String workPreference;
  final String location;
  final String image;
  final List<String> job;

  const UserEntity({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.school,
    required this.educationLevel,
    required this.workPreference,
    required this.location,
    required this.image,
    required this.job,
  });

  UserEntity copyWith({
    String? fullName,
    String? email,
    String? password,
    String? phoneNumber,
    String? school,
    String? educationLevel,
    String? workPreference,
    String? location,
    String? image,
    List<String>? job,
  }) {
    return UserEntity(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      school: school ?? this.school,
      educationLevel: educationLevel ?? this.educationLevel,
      workPreference: workPreference ?? this.workPreference,
      location: location ?? this.location,
      image: image ?? this.image,
      job: job ?? this.job,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'school': school,
      'educationLevel': educationLevel,
      'workPreference': workPreference,
      'location': location,
      'image': image,
      'job': job,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      fullName: map['fullName'] ?? "",
      email: map['email'] ?? "",
      password: map['password'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      school: map['school'] ?? "",
      educationLevel: map['educationLevel'] ?? "",
      workPreference: map['workPreference'] ?? "",
      location: map['location'] ?? "",
      image: map['image'] ?? "",
      job: List<String>.from(map['job'] ?? []),
    );
  }

  factory UserEntity.initial() {
    return const UserEntity(
      fullName: '',
      email: '',
      password: '',
      phoneNumber: '',
      school: '',
      educationLevel: '',
      workPreference: '',
      location: '',
      image: '',
      job: [],
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        password,
        phoneNumber,
        school,
        educationLevel,
        workPreference,
        location,
        image,
        job,
      ];
}
