import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterInitState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterFailState extends RegisterState {
  final String message;

  RegisterFailState({required this.message});

  @override
  List<Object?> get props => [message];
}
