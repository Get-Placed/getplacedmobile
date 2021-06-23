import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';
import 'package:get_placed/features/login/domain/usecases/login_usecase.dart';
import './bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login loginUseCase;

  LoginBloc(
    this.loginUseCase,
  ) : super(InitialLoginState());

  LoginState get initialState => InitialLoginState();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is CheckLoginEvent) {
      yield CheckingLoginState();
      final result = await loginUseCase.call(
        Params(
          login: LoginEntities(
            login: event.login.username,
            password: event.login.password,
          ),
        ),
      );
      yield result.fold(
        (failure) => ErrorLoggedState(),
        (value) => (value) ? LoggedState() : ErrorLoggedState(),
      );
    }
  }
}
