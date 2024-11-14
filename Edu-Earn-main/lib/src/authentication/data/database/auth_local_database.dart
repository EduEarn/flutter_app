import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:hive/hive.dart';

abstract class AuthLocalDatabase {
  void uploadUserInfo({required UserEntity userEntity});

  UserEntity loadUserInfo();
}

class AuthLocalDatabaseImpl implements AuthLocalDatabase {
  final Box userBox;

  AuthLocalDatabaseImpl({required this.userBox});

  // AuthLocalDatabaseImpl() : userBox = Hive.box(name: "userInfo");

  @override
  UserEntity loadUserInfo() {
    UserEntity user = UserEntity.initial();
    final userInfo = userBox.get("userInfo");
    if (userInfo != null && userInfo is Map<String, dynamic>) {
      user = UserEntity.fromMap(userInfo);
    }
    return user;
  }

  @override
  void uploadUserInfo({required UserEntity userEntity}) {
    userBox.clear();
    userBox.write(() {
      final user = userEntity.copyWith(password: "");
      userBox.put("userInfo", user.toMap());
    });
  }
}
