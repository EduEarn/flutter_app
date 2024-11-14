import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/company/entity/company.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/login_with_google_usecase.dart';
import '../../domain/usecase/signup_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _login;
  final SignUpUseCase _signUp;
  final ContinueWithGoogleUseCase _continueWithGoogle;

  AuthBloc({
    required LoginUseCase login,
    required SignUpUseCase signUp,
    required ContinueWithGoogleUseCase continueWithGoogle,
  })  : _login = login,
        _signUp = signUp,
        _continueWithGoogle = continueWithGoogle,
        super(AuthInitial()) {
    // on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final res = await _signUp(SignUpParams(company: event.company));
      return res.fold((failure) => emit(AuthFailure(failure.message)), (success) => emit(AuthSuccess()));
    });

    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final res = await _login(LoginParams(company: event.company));
      return res.fold((failure) => emit(AuthFailure(failure.message)), (success) => emit(AuthSuccess()));
    });

    on<ContinueWithGoogle>(
      (event, emit) async {
        emit(AuthLoading());
        final res = await _continueWithGoogle(NoGoogleParams());
        return res.fold(
            (failure) => emit(AuthFailure(failure.message)), (userCred) => emit(GoogleAuthSuccess(userCred: userCred)));
      },
    );
  }
}
