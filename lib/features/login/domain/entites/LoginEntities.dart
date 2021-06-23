import 'package:equatable/equatable.dart';

class LoginEntities extends Equatable {
  final String login;
  final String password;

  LoginEntities({
    required this.login,
    required this.password,
  });

  @override
  List<Object> get props => [login, password];
}
