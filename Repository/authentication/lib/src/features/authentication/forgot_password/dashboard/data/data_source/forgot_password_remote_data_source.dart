// ignore_for_file: one_member_abstracts

import 'package:auth_module/src/core/services/network/api_end_points.dart';
import 'package:auth_module/src/core/services/network/network_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';

part 'forgot_password_remote_data_source_impl.dart';

final forgotPasswordRemoteDataSourceProvider =
    Provider<ForgotPasswordRemoteDataSource>(
  (ref) {
    return ForgotPasswordRemoteDataSourceImp(
      restClient: ref.read(networkProvider),
    );
  },
);

abstract class ForgotPasswordRemoteDataSource {
  Future<Response> forgotPassword({required Map<String, dynamic> requestBody});
}
