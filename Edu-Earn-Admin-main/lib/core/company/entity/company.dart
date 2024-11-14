import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String name;
  final String email;
  final String password;
  final String logo;

  const Company({required this.name, required this.email, required this.password, required this.logo});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
