// ignore: file_names

import 'dart:async';

import 'package:sinque/src/application/repository/network.repository.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/core/providers.dart';

class NetworkUtil {
  static String? _networkUuid;

  static Future<String> retrieveUuid() async {
    if (_networkUuid != null) {
      return _networkUuid!;
    }

    NetworkRepository networkRepository =
        AppLocator().container.read(networkRepositoryProvider);

    _networkUuid = await networkRepository.retrieveUuid();

    return _networkUuid!;
  }

  static String retrieveUuidSync() {
    return _networkUuid!;
  }
}
