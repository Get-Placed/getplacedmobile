import 'package:flutter_test/flutter_test.dart';
import 'package:get_placed/features/login/domain/repositories/login_repository.dart';
import 'package:get_placed/features/login/domain/usecases/login_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:get_placed/features/login/domain/entites/LoginEntities.dart';
import 'login_test.mocks.dart';

class MockLoginRepository extends Mock implements LoginRepository {}

@GenerateMocks([MockLoginRepository])
void main() {
  late MockLoginRepository mockLoginRepository;
  late Login usecase;
  setUp(() {
    mockLoginRepository = MockMockLoginRepository();
    usecase = Login(mockLoginRepository);
  });

  final tLogin = LoginEntities(login: "login", password: "password");
  test('use case call repository', () async {
    //given
    when(
      mockLoginRepository.login(tLogin),
    ).thenAnswer((_) async => Right(true));
    //when
    final result = await usecase.call(Params(login: tLogin));
    //then
    expect(result, Right(true));
    verify(mockLoginRepository.login(tLogin));
    verifyNoMoreInteractions(mockLoginRepository);
  });
}
