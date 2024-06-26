import 'package:equatable/equatable.dart';

class RegisterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartRegistration extends RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String name;
  final String phone;
  final String email;
  final String password;

  RegisterButtonPressed({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, phone, email, password];
}
