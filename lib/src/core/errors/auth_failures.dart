abstract class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class UserNotFoundFailure extends AuthFailure {
  const UserNotFoundFailure()
    : super('Nenhum usuário encontrado para este e-mail');
}

class WrongPasswordFailure extends AuthFailure {
  const WrongPasswordFailure() : super('Senha incorreta. Tente novamente');
}

class InvalidEmailFailure extends AuthFailure {
  const InvalidEmailFailure()
    : super('O formato do e-mail inserido é inválido');
}

class ServerFailure extends AuthFailure {
  const ServerFailure([super.message = 'Erro de conexão com o servidor']);
}

class EmailAlreadyExistsFailure extends AuthFailure {
  const EmailAlreadyExistsFailure() : super('Este e-mail ja esta cadastrado');
}

class WeakPasswordFailure extends AuthFailure {
  const WeakPasswordFailure() : super('Senha muito fraca');
}

class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure([
    super.message = 'Ocorreu um erro inesperado na autenticação.',
  ]);
}
