part of 'login_notifier.dart';

class LoginState {
  LoginState({required this.isLoading});

  LoginState.initial() : isLoading = false;

  final bool isLoading;

  LoginState copyWith({bool? isLoading}) {
    return LoginState(isLoading: isLoading ?? this.isLoading);
  }
}
