import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:edu_earn/core/user/domain/entity/user.dart';

abstract class AuthRemoteDatabase {
  Future<void> login(UserEntity user);

  Future<void> signUp(UserEntity user);

  Future<UserEntity> getCurrentUserInfo();

  Future<UserCredential> continueWithGoogle();
}

class AuthRemoteDatabaseImpl implements AuthRemoteDatabase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserCredential> continueWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCred = await _auth.signInWithCredential(credential);
    if (userCred.additionalUserInfo!.isNewUser) {
      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'fullName': userCred.user!.displayName ?? "",
        'email': userCred.user!.email ?? "",
        'phoneNumber': userCred.user!.phoneNumber ?? "",
        'school': "",
        'educationLevel': "",
        'workPreference': "",
        'location': "",
        'image': "",
        'job': [],
      });
    }
    return userCred;
  }

  @override
  Future<void> login(UserEntity user) async {
    await _auth.signInWithEmailAndPassword(email: user.email, password: user.password);
  }

  @override
  Future<void> signUp(UserEntity user) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fullName': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'school': user.school,
      'educationLevel': user.educationLevel,
      'workPreference': user.workPreference,
      'location': user.location,
      'image': user.image,
      'job': user.job,
    });
  }

  @override
  Future<UserEntity> getCurrentUserInfo() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).get();
    final userInfo = UserEntity.fromMap(snapshot.data() ?? {});
    return userInfo;
  }
}
