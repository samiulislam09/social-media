import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/features/auth/domain/entities/app_user.dart';
import 'package:social_media/features/auth/domain/repository/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  late AppUser _appUser;
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      _appUser = (await authRepo.loginWithEmailPassword(email, password))!;
      emit(Authenticated(appUser: _appUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void register(String email, String password) async {
    emit(AuthLoading());
    try {
      _appUser = (await authRepo.registerWithEmailPassword(email, password))!;
      emit(Authenticated(appUser: _appUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void getCurrentUser() async {
    emit(AuthLoading());
    try {
      _appUser = (await authRepo.getCurrentUser())!;
      emit(Authenticated(appUser: _appUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void logout() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void checkAuthStatus() async {
    emit(AuthLoading());
    try {
      _appUser = (await authRepo.getCurrentUser())!;
      emit(Authenticated(appUser: _appUser));
    } catch (e) {
      emit(UnAuthenticated());
    }
  }
}
