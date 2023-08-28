part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class LoginWithEmailEvent extends HomeEvent{
  final String email;
  final String password;
  const LoginWithEmailEvent({required this.email,required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}


class SignUpEvent extends HomeEvent{
  final String email;
  final String password;
  const SignUpEvent({required this.email,required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];
}

class GoogleEvent extends HomeEvent{
  const GoogleEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}