import 'package:sinque/src/application/repository/network.repository.dart';
import 'package:sinque/src/core/appLocator.dart';
import 'package:sinque/src/infra/database/drift/appDatabase.dart';
import 'package:uuid/uuid.dart';

class NetworkRepositoryDraft extends NetworkRepository {
  final AppDatabase db = AppLocator().database;

  @override
  Future<String> retrieveUuid() async {
    final appData = await db.managers.appModel.get();

    if (appData.isEmpty) {
      final uuid = Uuid().v4();

      await db.managers.appModel.create((add) => add(uuid: uuid));

      return uuid;
    }

    return appData.first.uuid;
  }
}
