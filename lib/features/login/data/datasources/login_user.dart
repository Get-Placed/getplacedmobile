import 'package:get_placed/features/login/data/models/user.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';

class LoginUser {
  Future<User?> login(LoginEntities login) async {
    if (login.login == "user" && login.password == "password") {
      return User(id: 1, user: "admin");
    } else {
      return null;
    }
  }
}
