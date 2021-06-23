import 'package:equatable/equatable.dart';

class LoginDTO extends Equatable {
  final String username;
  final String password;

  LoginDTO({
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [
        username,
        password,
      ];
}
