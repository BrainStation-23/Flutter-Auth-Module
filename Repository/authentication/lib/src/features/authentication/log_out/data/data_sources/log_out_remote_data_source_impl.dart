import 'package:auth_module/src/core/services/network/api_end_points.dart';
import 'package:auth_module/src/core/services/network/network_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';

part 'log_out_remote_data_source.dart';

class LogOutRemoteDataSourceImp implements LogOutRemoteDataSource {
  const LogOutRemoteDataSourceImp({required this.restClient});

  final RestClient restClient;

  @override
  Future<Response> logOut() async {
    final response = restClient.post(
      APIType.protected,
      API.logOut,
      {},
    );

    return response;
  }
}
