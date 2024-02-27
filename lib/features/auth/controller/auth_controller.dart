import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/repository/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _ref = ref,
        _authRepository = authRepository,
        super(false);

  void signInWithGoogle() async {
    _ref.read(userProvider.notifier).update((state) => null);
    final user = await _authRepository.signInWithGoogle();
    _ref.read(userProvider.notifier).update((state) => user);
  }
}
