import 'package:edu_earn/core/user/domain/entity/user.dart';
import 'package:edu_earn/src/authentication/domain/usecases/login_with_google_usecase.dart';
import 'package:edu_earn/src/authentication/domain/usecases/signup_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _login;
  final SignUpUseCase _signUp;
  final ContinueWithGoogleUseCase _continueWithGoogle;
  final GetCurrentUserInfo _getCurrentUserInfo;

  AuthBloc({
    required LoginUseCase login,
    required SignUpUseCase signUp,
    required GetCurrentUserInfo getCurrentUserInfo,
    required ContinueWithGoogleUseCase continueWithGoogle,
  })  : _login = login,
        _signUp = signUp,
        _getCurrentUserInfo = getCurrentUserInfo,
        _continueWithGoogle = continueWithGoogle,
        super(AuthInitial()) {
    // on<AuthEvent>((event, emit) => emit(AuthLoading()));
    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      final res = await _signUp(SignUpParams(user: event.user));
      return res.fold((failure) => emit(AuthFailure(failure.message)), (success) => emit(AuthSuccess()));
    });

    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final res = await _login(LoginParams(user: event.user));
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

    on<GetUserInfo>((event, emit) async {
      final res = await _getCurrentUserInfo(NoParams());
      return res.fold(
          (failure) => emit(AuthFailure(failure.message)), (userInfo) => emit(UserInfoLoaded(user: userInfo)));
    });
  }
}
