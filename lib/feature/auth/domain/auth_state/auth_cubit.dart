import 'package:client_id/app/domain/error_entity/error_entity.dart';
import 'package:client_id/feature/auth/domain/auth_repository.dart';
import 'package:client_id/feature/auth/domain/entities/user_entity/user_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part "auth_state.dart";

part "auth_cubit.freezed.dart";

part "auth_cubit.g.dart";

@Singleton()
class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit(this.authRepository) : super(AuthState.notAuthorized());

  final AuthRepository authRepository;

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(AuthState.waiting());
    try {
      final UserEntity userEntity =
          await authRepository.singIn(password: password, username: username);
      emit(AuthState.authorized(userEntity));
    } catch (error, st) {
      addError(error, st);
    }
  }

  Future<void> signUp({
    required String username,
    required String password,
    required String email,
  }) async {
    emit(AuthState.waiting());
    try {
      final UserEntity userEntity = await authRepository.singUp(
          password: password, username: username, email: email);
      emit(AuthState.authorized(userEntity));
    } catch (error, st) {
      addError(error, st);
    }
  }

  Future<void> refreshToken() async {
    final refreshToken =
        state.whenOrNull(authorized: (userEntity) => userEntity.refreshToken);
    try {
      final UserEntity userEntity =
          await authRepository.refreshToken(refreshToken: refreshToken);
      emit(AuthState.authorized(userEntity));
    } catch (error, st) {
      addError(error, st);
    }
  }

  Future<void> getProfile() async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      final UserEntity newUserEntity = await authRepository.getProfile();
      emit(state.maybeWhen(
        orElse: () => state,
        authorized: (userEntity) => AuthState.authorized(userEntity.copyWith(
            email: newUserEntity.email, username: newUserEntity.username)),
      ));
      _updateUserState(const AsyncSnapshot.withData(
          ConnectionState.done, "Complete get data"));
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

  // TODO description
  Future<void> userUpdate({String? username, String? email, String? description}) async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      await Future.delayed(const Duration(seconds: 1));
      final bool isEmptyUsername = username?.trim().isEmpty == true;
      final bool isEmptyEmail = email?.trim().isEmpty == true;
      final bool isEmptyDescription = description?.trim().isEmpty == true;
      final UserEntity newUserEntity = await authRepository.userUpdate(
        username: isEmptyUsername ? null : username,
        email: isEmptyEmail ? null : email,
        description: isEmptyDescription ? null : description,
      );
      emit(state.maybeWhen(
        orElse: () => state,
        authorized: (userEntity) => AuthState.authorized(userEntity.copyWith(
            email: newUserEntity.email, username: newUserEntity.username, description: newUserEntity.description)),
      ));
      _updateUserState(const AsyncSnapshot.withData(
          ConnectionState.done, "Complete update data"));
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

  Future<void> passwordUpdate(
      {required String oldPassword, required String newPassword}) async {
    try {
      _updateUserState(const AsyncSnapshot.waiting());
      await Future.delayed(const Duration(seconds: 1));
      if (newPassword.trim().isEmpty == true) {
        throw ErrorEntity(message: "New password is null!");
      }
      final message = await authRepository.passwordUpdate(
          newPassword: newPassword, oldPassword: oldPassword);

      _updateUserState(AsyncSnapshot.withData(
          ConnectionState.done, message));
    } catch (error) {
      _updateUserState(AsyncSnapshot.withError(ConnectionState.done, error));
    }
  }

// todo logout
  void logOut() => emit(AuthState.notAuthorized());

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    final state = AuthState.fromJson(json);
    return state.whenOrNull(
      authorized: (userEntity) => AuthState.authorized(userEntity),
    );
  }

  void _updateUserState(AsyncSnapshot asyncSnapshot) {
    emit(state.maybeWhen(
        orElse: () => state,
        authorized: (userEntity) {
          return AuthState.authorized(
              userEntity.copyWith(userState: asyncSnapshot));
        }));
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    // save state
    return state
            .whenOrNull(
              authorized: (userEntity) => AuthState.authorized(userEntity),
            )
            ?.toJson() ??
        AuthState.notAuthorized().toJson();
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    emit(AuthState.error(error));
    super.addError(error, stackTrace);
  }
}
