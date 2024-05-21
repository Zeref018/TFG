part of 'login_cubit.dart';

class LoginState extends Equatable {
  final PageStatusEnum? pageStatus;
  final String? error;
  final TextEditingController? usernameInput;
  final TextEditingController? hashtagInput;

  const LoginState(
      {this.pageStatus, this.error, this.usernameInput, this.hashtagInput});

  LoginState copyWithProps(
      {PageStatusEnum? pageStatus,
      String? error,
      TextEditingController? emailInput,
      TextEditingController? passwordInput}) {
    return LoginState(
        pageStatus: pageStatus ?? this.pageStatus,
        error: error ?? this.error,
        usernameInput: emailInput ?? this.usernameInput,
        hashtagInput: passwordInput ?? this.hashtagInput);
  }

  @override
  List<dynamic> get props => [pageStatus, error, usernameInput, hashtagInput];
}
