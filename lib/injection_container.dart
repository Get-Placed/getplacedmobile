import 'package:get_it/get_it.dart';
import 'features/login/data/datasources/login_user.dart';
import 'features/login/data/repositories/login_repository_impl.dart';
import 'features/login/domain/repositories/login_repository.dart';
import 'features/login/domain/usecases/login_usecase.dart';
import 'features/login/presentation/bloc/login_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  initInjections(serviceLocator);
}

void initInjections(GetIt serviceLocator) {
  serviceLocator.registerFactory(
    () => LoginBloc(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => Login(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => LoginUser(),
  );
}
