import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repository/auth_repo.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {

  AuthRepository repo;

  RegisterBloc(RegisterState initialState, this.repo): super(initialState){

    on<StartRegistration>((event, emit){
      emit(RegisterInitState());
    });

    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoadingState());
      try {
        int result = await repo.register(
          event.name,
          event.phone,
          event.email,
          event.password,
        );
        if (result == 0) {
          emit(RegisterSuccessState());
        } else if (result == 1) {
          emit(RegisterFailState(message: 'Registration failed: Invalid email address'));
        } else if (result == 2) {
          emit(RegisterFailState(message: 'Registration failed: Password is too weak'));
        } else {
          emit(RegisterFailState(message: 'Registration failed: Unknown error occurred'));
        }
      } catch (e) {
        emit(RegisterFailState(message: 'Failed to register: $e'));
      }
    });
  }
}
