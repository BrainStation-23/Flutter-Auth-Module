import 'dart:async';

import 'package:auth_module/src/core/services/local_storage/cache_service.dart';
import 'package:auth_module/src/core/services/network/request_handler.dart';
import 'package:auth_module/src/features/authentication/sign_in/data/data_sources/sign_in_local_data_source.dart';
import 'package:auth_module/src/features/authentication/sign_in/data/data_sources/sign_in_remote_data_source.dart';
import 'package:auth_module/src/features/authentication/sign_in/data/models/sign_in_model.dart';
import 'package:auth_module/src/features/authentication/sign_in/domain/entities/sign_in_entity.dart';
import 'package:auth_module/src/features/authentication/sign_in/domain/repositories/sign_in_repositories.dart';

class SignInRepositoryImp implements SignInRepository {
  SignInRepositoryImp({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final SignInRemoteDataSource remoteDataSource;
  final SignInLocalDataSource localDataSource;

  @override
  Future<(String, dynamic)> signIn({
    required Map<String, dynamic> requestBody,
    required bool rememberMeState,
    required bool offlineState,
  }) async {
    manageCredentials(
      email: requestBody['email'],
      password: requestBody['password'],
      rememberMeState: rememberMeState,
    );

    if (offlineState) {
      final response = await localDataSource.signIn(requestBody: requestBody);
      return Future.value((response.statusMessage!, true));
    }

    return remoteDataSource.signIn(requestBody: requestBody).guard((data) {
      final SignInEntity entity = SignInModel.fromJson(data);
      CacheService.instance.storeBearerToken(entity.token);
      CacheService.instance.storeProfileId(entity.user.id);
      CacheService.instance.storeFullName(
        entity.user.firstName!,
        entity.user.lastName!,
      );
      return data;
    });
  }

  @override
  Future<String?> decideNextRoute() async {
    final token = await CacheService.instance.retrieveBearerToken();

    return token;
  }

  @override
  Future<Map<String, dynamic>?> getStoredCredentials() async {
    final credentials = await CacheService.instance.retrieveCredentials();

    if (credentials != null) {
      return credentials;
    }

    return null;
  }

  Future<void> manageCredentials({
    required String email,
    required String password,
    required bool rememberMeState,
  }) async {
    if (rememberMeState) {
      await CacheService.instance.storeCredentials({
        'userEmail': email,
        'password': password,
      });
    } else {
      await CacheService.instance.clearCredentials();
    }
  }
}
