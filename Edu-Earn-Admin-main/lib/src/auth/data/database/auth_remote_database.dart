import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/company/entity/company.dart';

abstract class AuthRemoteDatabase {
  Future<void> login(Company company);

  Future<void> signUp(Company company);

  Future<UserCredential> continueWithGoogle();
}

class AuthRemoteDatabaseImpl implements AuthRemoteDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> login(Company company) async {
    await _auth.signInWithEmailAndPassword(email: company.email, password: company.password);
  }

  @override
  Future<void> signUp(Company company) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: company.email,
      password: company.password,
    );
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection('companies').doc(uid).set({
      'id': uid,
      'name': company.name,
      'email': company.email,
      'logo': '',
      'company_mission': "",
      'about_company': ""
    });
  }

  @override
  Future<UserCredential> continueWithGoogle() {
    // TODO: implement continueWithGoogle
    throw UnimplementedError();
  }
}
