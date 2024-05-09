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
      String? result = (await repo.register(
        event.name,
        event.email,
        event.password,
      )) as String?;
      if (result != null && result == '0') {
        emit(RegisterSuccessState());
      } else {
        emit(RegisterFailState(message: 'Failed to register'));
      }
    });

  }
}
